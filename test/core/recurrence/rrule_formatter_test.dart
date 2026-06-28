import 'package:courrier/core/recurrence/rrule_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final formatter = RruleFormatter();

  group('RruleFormatter — common patterns', () {
    test('FREQ=DAILY → "Daily"', () {
      expect(formatter.format('FREQ=DAILY'), 'Daily');
    });

    test('FREQ=DAILY;INTERVAL=3 → "Every 3 days"', () {
      expect(formatter.format('FREQ=DAILY;INTERVAL=3'), 'Every 3 days');
    });

    test(
      'FREQ=WEEKLY;BYDAY=MO,WE,FR → "Weekly on Monday, Wednesday, and Friday"',
      () {
        expect(
          formatter.format('FREQ=WEEKLY;BYDAY=MO,WE,FR'),
          'Weekly on Monday, Wednesday, and Friday',
        );
      },
    );

    test('FREQ=WEEKLY;INTERVAL=2;BYDAY=TU → "Every 2 weeks on Tuesday"', () {
      expect(
        formatter.format('FREQ=WEEKLY;INTERVAL=2;BYDAY=TU'),
        'Every 2 weeks on Tuesday',
      );
    });

    test('FREQ=MONTHLY;BYMONTHDAY=15 → "Monthly on the 15th"', () {
      expect(
        formatter.format('FREQ=MONTHLY;BYMONTHDAY=15'),
        'Monthly on the 15th',
      );
    });

    test(
      'FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25 → "Yearly on the 25th in December"',
      () {
        expect(
          formatter.format('FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25'),
          'Yearly on the 25th in December',
        );
      },
    );

    test('COUNT carries through', () {
      expect(formatter.format('FREQ=DAILY;COUNT=10'), 'Daily, 10 times');
    });

    test('UNTIL carries through', () {
      final result = formatter.format('FREQ=WEEKLY;UNTIL=20270630T000000Z');
      expect(result, contains('Weekly'));
      expect(result, contains('until'));
      expect(result, contains('Jun'));
    });

    test('FREQ=MONTHLY;BYDAY=2MO (second Monday) → ordinal prefix', () {
      final result = formatter.format('FREQ=MONTHLY;BYDAY=2MO');
      expect(result, contains('on the 2nd Monday'));
    });

    test('Malformed input → "Custom recurrence"', () {
      expect(formatter.format('THIS IS NOT VALID'), 'Custom recurrence');
    });
  });
}
