import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/components/function/main_function.dart';

/// Concrete test class karena DatetimeComponent adalah mixin
class _TestDatetime with DatetimeComponent {}

void main() {
  late _TestDatetime component;

  setUp(() {
    component = _TestDatetime();
  });

  group('DatetimeComponent', () {
    test('date() formats yyyy-MM-dd correctly', () {
      /// Validates: Requirements 16.1
      expect(
        component.date(format: 'yyyy-MM-dd', dateTime: DateTime(2024, 1, 15)),
        '2024-01-15',
      );
    });

    test('date() formats dd-MM-yyyy correctly', () {
      /// Validates: Requirements 16.2
      expect(
        component.date(format: 'dd-MM-yyyy', dateTime: DateTime(2024, 12, 31)),
        '31-12-2024',
      );
    });

    test('datetime() matches regex format yyyy-MM-dd HH:mm:ss', () {
      /// Validates: Requirements 16.3
      final result = component.datetime();
      expect(
        RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$').hasMatch(result),
        isTrue,
        reason:
            'datetime() returned "$result" which does not match expected format',
      );
    });
  });

  group('Property Tests', () {
    test('Property 23: date() is idempotent for any format and DateTime', () {
      // Feature: unit-testing, Property 23: DatetimeComponent Idempotence
      // **Validates: Requirements 16.3, 16.4**
      final formats = [
        'yyyy-MM-dd',
        'dd-MM-yyyy',
        'HH:mm:ss',
        'yyyy/MM/dd HH:mm',
        'dd MMMM yyyy',
        'EEE, dd MMM yyyy',
      ];
      for (int i = 0; i < 100; i++) {
        final format = formats[i % formats.length];
        final dt = DateTime(
          2020 + (i % 5),
          (i % 12) + 1,
          (i % 28) + 1,
          i % 24,
          i % 60,
          i % 60,
        );

        final result1 = component.date(format: format, dateTime: dt);
        final result2 = component.date(format: format, dateTime: dt);

        expect(
          result1,
          result2,
          reason: 'format="$format", dt=$dt: "$result1" != "$result2"',
        );
      }
    });
  });
}
