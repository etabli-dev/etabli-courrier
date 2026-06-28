import 'dart:convert';

import 'ical_component.dart';

// Serialise an IcalComponent tree back to text, with RFC 5545 §3.1 line
// folding: content lines longer than 75 OCTETS (UTF-8 byte length, not Dart
// code-unit length) are split with CRLF + a single SP, repeatedly.
//
// We measure by OCTETS because RFC 5545 explicitly mandates octet, not
// character, boundaries; folding inside a multi-byte UTF-8 sequence is illegal
// and corrupts content on round-trip.

const String _crlf = '\r\n';
const int _maxOctets = 75;

class IcalWriter {
  const IcalWriter();

  String render(IcalComponent root) {
    final buffer = StringBuffer();
    _renderComponent(root, buffer);
    return buffer.toString();
  }

  void _renderComponent(IcalComponent component, StringBuffer out) {
    _foldAndWrite('BEGIN:${component.name}', out);
    for (final property in component.properties) {
      _foldAndWrite(property.renderUnfolded(), out);
    }
    for (final child in component.children) {
      _renderComponent(child, out);
    }
    _foldAndWrite('END:${component.name}', out);
  }

  void _foldAndWrite(String logicalLine, StringBuffer out) {
    final bytes = utf8.encode(logicalLine);
    if (bytes.length <= _maxOctets) {
      out
        ..write(logicalLine)
        ..write(_crlf);
      return;
    }
    var offset = 0;
    var first = true;
    while (offset < bytes.length) {
      // Each continuation line starts with a SP, so it can carry 74 more octets.
      final budget = first ? _maxOctets : _maxOctets - 1;
      var end = offset + budget;
      if (end > bytes.length) {
        end = bytes.length;
      } else {
        // Step back so we don't slice through a multi-byte UTF-8 sequence.
        // Continuation bytes have the form 10xxxxxx (0x80..0xBF).
        while (end > offset && (bytes[end] & 0xC0) == 0x80) {
          end -= 1;
        }
      }
      final slice = utf8.decode(bytes.sublist(offset, end));
      if (!first) {
        out.write(' ');
      }
      out
        ..write(slice)
        ..write(_crlf);
      offset = end;
      first = false;
    }
  }
}
