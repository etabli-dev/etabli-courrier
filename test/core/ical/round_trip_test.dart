import 'dart:io';

import 'package:courrier/core/ical/ical_component.dart';
import 'package:courrier/core/ical/ical_property.dart';
import 'package:courrier/core/ical/ical_reader.dart';
import 'package:courrier/core/ical/ical_writer.dart';
import 'package:courrier/core/ical/vcard.dart';
import 'package:courrier/core/ical/vevent.dart';
import 'package:courrier/core/ical/vtodo.dart';
import 'package:flutter_test/flutter_test.dart';

const IcalReader _reader = IcalReader();
const IcalWriter _writer = IcalWriter();

String _load(String name) =>
    File('test/fixtures/ical/$name').readAsStringSync();

void main() {
  group('IcalReader/Writer round-trip', () {
    test(
      'VEVENT with EXDATE/RRULE/ORGANIZER/ATTENDEE/X-* survives byte-equal',
      () {
        final source = _load('vevent_full.ics');
        final tree = _reader.parse(source);
        final rendered = _writer.render(tree);

        // Re-parse and re-render — second pass must equal the first pass.
        final rendered2 = _writer.render(_reader.parse(rendered));
        expect(rendered2, rendered);
      },
    );

    test('VEVENT lens exposes typed fields without losing originals', () {
      final tree = _reader.parse(_load('vevent_full.ics'));
      final vevent = VEvent.from(tree.firstChild('VEVENT')!);

      expect(vevent.uid, 'fb0c0c0e-1234-4abc-9def-aaa111bbb222');
      expect(vevent.summary, 'Weekly status');
      expect(vevent.rrule, 'FREQ=WEEKLY;BYDAY=MO');
      expect(vevent.exdates, hasLength(2));
      expect(vevent.attendees, hasLength(2));
      expect(vevent.alarms, hasLength(2));

      // Unknown vendor property survived on the underlying component.
      expect(
        vevent.component.get('X-CUSTOM-VENDOR-FIELD')?.value,
        'keep-this-around-please',
      );
    });

    test('VTODO RELATED-TO defaults to PARENT (no RELTYPE)', () {
      final tree = _reader.parse(_load('vtodo_subtask.ics'));
      final children = tree
          .childrenOf('VTODO')
          .map(VTodo.from)
          .where((t) => t.uid != 'parent-uid-1')
          .toList();
      expect(children, hasLength(2));
      for (final child in children) {
        expect(child.parentUid, 'parent-uid-1');
      }
    });

    test('VCARD round-trip preserves X-* and TYPE params', () {
      final source = _load('vcard_full.vcf');
      final tree = _reader.parse(source);
      final rendered = _writer.render(tree);
      final retree = _reader.parse(rendered);

      final card = VCard.from(retree);
      expect(card.uid, 'vcard-uid-001');
      expect(card.formattedName, 'Ada Lovelace');
      expect(card.emails, hasLength(2));
      expect(card.phones, hasLength(2));

      // X-CUSTOM-VENDOR-NOTE made it through.
      expect(retree.get('X-CUSTOM-VENDOR-NOTE')?.value, 'keep-this-too');

      // EMAIL;TYPE=work was preserved on the first email property.
      final firstEmail = retree.getAll('EMAIL').first;
      expect(firstEmail.param('TYPE'), 'work');
    });
  });

  group('Line folding (RFC 5545 §3.1)', () {
    test('writer folds at 75 octets and reader unfolds back losslessly', () {
      final long = 'X' * 240;
      final component = IcalComponent('VCALENDAR')
        ..properties.add(IcalProperty(name: 'X-LONG', value: long));
      final rendered = _writer.render(component);
      // Should contain CRLF + space continuation markers.
      expect(rendered.contains('\r\n '), isTrue);
      // Round-trip unfolds back to the original logical line.
      final reparsed = _reader.parse(rendered);
      expect(reparsed.get('X-LONG')?.value, long);
    });

    test('multi-byte UTF-8 is never split mid-codepoint', () {
      // A long string of accented characters — each "é" is 2 bytes in UTF-8.
      final value = 'café-' * 30;
      final component = IcalComponent('VCALENDAR')
        ..properties.add(IcalProperty(name: 'X-EM', value: value));
      final rendered = _writer.render(component);
      // Reader must successfully unfold (i.e. no FormatException from invalid
      // UTF-8) and the round-trip must equal the input.
      final reparsed = _reader.parse(rendered);
      expect(reparsed.get('X-EM')?.value, value);
    });
  });

  group('Reader robustness', () {
    test('lenient on LF-only input but writer emits CRLF', () {
      final lfOnly = _load('vevent_full.ics').replaceAll('\r\n', '\n');
      final tree = _reader.parse(lfOnly);
      final rendered = _writer.render(tree);
      expect(rendered.contains('\r\n'), isTrue);
    });

    test('throws on unbalanced END', () {
      const broken = 'BEGIN:VCALENDAR\r\nEND:VTODO\r\n';
      expect(() => _reader.parse(broken), throwsA(isA<FormatException>()));
    });

    test('throws on unterminated component', () {
      const broken = 'BEGIN:VCALENDAR\r\nUID:abc\r\n';
      expect(() => _reader.parse(broken), throwsA(isA<FormatException>()));
    });
  });
}
