import 'package:flutter_test/flutter_test.dart';
import 'package:calunedar/calendar/coligny_calendar.dart';

void main() {
  group('gregorian to coligny', () {
    group('converts correctly', () {
      group('metonic', () {
        var inputsToExpected = {
          DateTime(2021, 6, 17): ColignyCalendar(5021, 2, 1, true),
          DateTime(2021, 7, 9): ColignyCalendar(5021, 2, 23, true)
        };
        inputsToExpected.forEach((input, expected) {
          test('$input to $expected', () {
            expect(ColignyCalendar.fromDateTime(input, true), equals(expected));
          });
        });
      });

      group('non-metonic', () {
        var inputsToExpected = {
          DateTime(2021, 6, 17): ColignyCalendar(5021, 1, 1),
          DateTime(2021, 7, 9): ColignyCalendar(5021, 1, 23)
        };
        inputsToExpected.forEach((input, expected) {
          test('$input to $expected', () {
            expect(ColignyCalendar.fromDateTime(input), equals(expected));
          });
        });
      });
    });

    group('converts correctly "after sundown"', () {
      group('metonic', () {
        var metonicInputsToExpected = {
          DateTime(2021, 6, 17, 18): ColignyCalendar(5021, 2, 2, true),
          DateTime(2021, 7, 9, 18): ColignyCalendar(5021, 2, 24, true)
        };
        metonicInputsToExpected.forEach((input, expected) {
          test('$input to $expected', () {
            expect(ColignyCalendar.fromDateTime(input, true), equals(expected));
          });
        });
      });

      group('non-metonic', () {
        var nonMetonicInputsToexpected = {
          DateTime(2021, 6, 17, 18): ColignyCalendar(5021, 1, 2),
          DateTime(2021, 7, 9, 18): ColignyCalendar(5021, 1, 24)
        };
        nonMetonicInputsToexpected.forEach((input, expected) {
          test('$input to $expected (non-metonic)', () {
            expect(ColignyCalendar.fromDateTime(input), equals(expected));
          });
        });
      });
    });
  });

  group('coligny to gregorian', () {
    group('converts correctly', () {
      group('metonic', () {
        var inputsToExpected = {
          ColignyCalendar(5021, 2, 1, true): DateTime(2021, 6, 17),
          ColignyCalendar(5021, 2, 23, true): DateTime(2021, 7, 9)
        };
        inputsToExpected.forEach((input, expected) {
          test('$input to $expected', () {
            expect(input.toDateTime(), equals(expected));
          });
        });
      });

      group('non-metonic', () {
        var inputsToExpected = {
          ColignyCalendar(5021, 1, 1): DateTime(2021, 6, 17),
          ColignyCalendar(5021, 1, 23): DateTime(2021, 7, 9)
        };
        inputsToExpected.forEach((input, expected) {
          test('$input to $expected', () {
            expect(input.toDateTime(), equals(expected));
          });
        });
      });
    });
  });
}
