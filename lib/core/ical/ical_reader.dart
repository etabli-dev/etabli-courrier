import 'ical_component.dart';
import 'ical_property.dart';

// Parse an RFC 5545 iCalendar object or an RFC 6350 vCard into an IcalComponent
// tree. Lossless: every line, in original order, lands either as a property of
// the current component or as a child BEGIN/END block. Unknown property names
// are NOT discarded.
//
// Line endings: input may use CRLF (canonical) or LF (lenient). We normalise
// for parsing but the writer always emits CRLF (RFC 5545 §3.1).
//
// Line unfolding: any CRLF (or LF) followed by a SPACE or TAB is the
// continuation of the previous logical line — concatenate after dropping the
// CRLF + space/tab.
//
// Top-level: a single component (e.g. VCALENDAR, VCARD). For vCard objects
// containing multiple cards or iCalendar streams with multiple VCALENDARs,
// callers may use `parseAll`.

class IcalReader {
  const IcalReader();

  IcalComponent parse(String input) {
    final all = parseAll(input);
    if (all.isEmpty) {
      throw const FormatException('iCal/vCard input contained no components');
    }
    return all.first;
  }

  List<IcalComponent> parseAll(String input) {
    final lines = _unfold(input);
    final iter = lines.iterator;
    final roots = <IcalComponent>[];
    while (iter.moveNext()) {
      final line = iter.current;
      if (line.isEmpty) {
        continue;
      }
      final prop = _parseLine(line);
      if (prop.name != 'BEGIN') {
        throw FormatException(
          'Top-level lines must be BEGIN:NAME; got "${prop.name}"',
        );
      }
      final component = IcalComponent(prop.value);
      _readBody(iter, component);
      roots.add(component);
    }
    return roots;
  }

  void _readBody(Iterator<String> iter, IcalComponent current) {
    while (iter.moveNext()) {
      final line = iter.current;
      if (line.isEmpty) {
        continue;
      }
      final prop = _parseLine(line);
      if (prop.name == 'BEGIN') {
        final child = IcalComponent(prop.value);
        _readBody(iter, child);
        current.children.add(child);
        continue;
      }
      if (prop.name == 'END') {
        if (prop.value.toUpperCase() != current.name) {
          throw FormatException(
            'Unbalanced component: expected END:${current.name}, '
            'got END:${prop.value}',
          );
        }
        return;
      }
      current.properties.add(prop);
    }
    throw FormatException('Unterminated component: ${current.name}');
  }

  // ---- Tokenisation ------------------------------------------------------

  /// Split [input] on CRLF/LF and unfold per RFC 5545 §3.1.
  List<String> _unfold(String input) {
    // Normalise to LF; the unfolder treats LF-space (or LF-tab) as continuation.
    final normalised = input.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    final raw = normalised.split('\n');
    final unfolded = <String>[];
    for (final line in raw) {
      if (unfolded.isNotEmpty &&
          line.isNotEmpty &&
          (line.codeUnitAt(0) == 0x20 || line.codeUnitAt(0) == 0x09)) {
        unfolded[unfolded.length - 1] = unfolded.last + line.substring(1);
      } else {
        unfolded.add(line);
      }
    }
    return unfolded;
  }

  /// Parse one unfolded content line into a property.
  IcalProperty _parseLine(String line) {
    // Walk the name + params up to the unquoted ':'.
    var i = 0;
    final length = line.length;
    while (i < length && line[i] != ':' && line[i] != ';') {
      i += 1;
    }
    if (i == 0 || i == length) {
      throw FormatException('Content line missing value separator: "$line"');
    }
    final name = line.substring(0, i);
    final parameters = <String, List<String>>{};
    while (i < length && line[i] == ';') {
      i += 1; // consume ';'
      final paramStart = i;
      while (i < length && line[i] != '=') {
        i += 1;
      }
      if (i == length) {
        throw FormatException('Parameter missing value: "$line"');
      }
      final paramName = line.substring(paramStart, i).toUpperCase();
      i += 1; // consume '='
      final values = <String>[];
      while (true) {
        final result = _consumeParamValue(line, i);
        values.add(result.value);
        i = result.nextIndex;
        if (i < length && line[i] == ',') {
          i += 1;
          continue;
        }
        break;
      }
      (parameters[paramName] ??= <String>[]).addAll(values);
    }
    if (i >= length || line[i] != ':') {
      throw FormatException('Content line missing ":" separator: "$line"');
    }
    final value = line.substring(i + 1);
    return IcalProperty(name: name, parameters: parameters, value: value);
  }

  _ParamValue _consumeParamValue(String line, int start) {
    final length = line.length;
    if (start < length && line[start] == '"') {
      final end = line.indexOf('"', start + 1);
      if (end < 0) {
        throw FormatException('Unterminated quoted parameter: "$line"');
      }
      return _ParamValue(
        value: line.substring(start + 1, end),
        nextIndex: end + 1,
      );
    }
    var i = start;
    while (i < length && line[i] != ',' && line[i] != ';' && line[i] != ':') {
      i += 1;
    }
    return _ParamValue(value: line.substring(start, i), nextIndex: i);
  }
}

class _ParamValue {
  const _ParamValue({required this.value, required this.nextIndex});
  final String value;
  final int nextIndex;
}
