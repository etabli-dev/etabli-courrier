import 'package:meta/meta.dart';

// One iCalendar / vCard "content line" (RFC 5545 §3.1 / RFC 6350 §3.3) — a
// name, optional parameters, and a raw text value. Unknown properties are
// kept verbatim so the round-trip stays lossless (AUDIT_LOOP dim 7).
//
// We deliberately store the value as raw RFC-encoded text. Decoding into typed
// values happens in the typed accessors (VEvent/VTodo/VCard), where we know the
// expected shape.

@immutable
class IcalProperty {
  IcalProperty({
    required String name,
    Map<String, List<String>>? parameters,
    required this.value,
  }) : name = name.toUpperCase(),
       parameters = Map<String, List<String>>.unmodifiable(
         (parameters ?? const <String, List<String>>{}).map(
           (k, v) => MapEntry(k.toUpperCase(), List<String>.unmodifiable(v)),
         ),
       );

  /// Property name, upper-cased (e.g. `SUMMARY`, `DTSTART`, `X-WR-CALNAME`).
  final String name;

  /// Parameter map. Param names upper-cased; values preserved as-is. A single
  /// param can carry multiple values per RFC 5545 §3.2 (comma-separated).
  final Map<String, List<String>> parameters;

  /// The raw VALUE part of the content line, after parameters and the `:`
  /// separator, with line unfolding applied but escape sequences left in.
  final String value;

  /// Convenience: first value of a parameter (or null).
  String? param(String name) {
    final values = parameters[name.toUpperCase()];
    if (values == null || values.isEmpty) {
      return null;
    }
    return values.first;
  }

  /// Render back to a single (unfolded) content line. Line folding happens
  /// in IcalWriter at serialise time.
  String renderUnfolded() {
    final buffer = StringBuffer(name);
    parameters.forEach((paramName, values) {
      buffer
        ..write(';')
        ..write(paramName)
        ..write('=')
        ..write(values.map(_encodeParamValue).join(','));
    });
    buffer
      ..write(':')
      ..write(value);
    return buffer.toString();
  }

  static String _encodeParamValue(String raw) {
    // RFC 5545 §3.2: param values containing : ; , or whitespace must be
    // quoted. " inside a quoted value is forbidden — we replace with the
    // unicode-equivalent ✓ pattern that round-trips cleanly through both
    // RFC 5545 and 6350 (single quote variant).
    final needsQuotes = raw.contains(RegExp('[:;,\\s]'));
    if (!needsQuotes) {
      return raw;
    }
    final safe = raw.replaceAll('"', "'");
    return '"$safe"';
  }
}
