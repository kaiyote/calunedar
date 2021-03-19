import 'package:flutter_test/flutter_test.dart';

import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:dart_date/dart_date.dart';

void main() {
  group('Coligny Calendar', () {
    test('it can convert back and forth correctly', () {
      DateTime metonicNow = ColignyCalendar.now(true).toDateTime();
      DateTime saturnicNow = ColignyCalendar.now().toDateTime();

      expect(metonicNow.isSameDay(saturnicNow), isTrue);
      expect(metonicNow.isToday, isTrue);
    });

    final inputsToBeExpected = {
      DateTime(2021, 2, 19): [
        ColignyCalendar(5020, 10, 1, true),
        ColignyCalendar(5020, 9, 30)
      ],
      DateTime(2020, 3, 31): [
        ColignyCalendar(5019, 12, 1, true),
        ColignyCalendar(5019, 11, 1)
      ]
    };

    inputsToBeExpected.forEach((input, expected) {
      test('it will make the correct coligny date from gregorian $input', () {
        expect(ColignyCalendar.fromDateTime(input, true), equals(expected[0]));
        expect(ColignyCalendar.fromDateTime(input), equals(expected[1]));
      });
    });

    final metonicTestStartDate = ColignyCalendar(5020, 10, 29, true);
    final saturnTestStartDate = ColignyCalendar(5020, 10, 28);
    final daysInputToBeExpected = {
      -1: [ColignyCalendar(5020, 10, 28, true), ColignyCalendar(5020, 10, 27)],
      1: [ColignyCalendar(5020, 11, 1, true), ColignyCalendar(5020, 10, 29)],
      30: [ColignyCalendar(5020, 11, 30, true), ColignyCalendar(5020, 11, 29)],
    };

    daysInputToBeExpected.forEach((daysToAdd, expectedDates) {
      test('will add $daysToAdd days correctly', () {
        expect(
            metonicTestStartDate.addDays(daysToAdd), equals(expectedDates[0]));
        expect(
            saturnTestStartDate.addDays(daysToAdd), equals(expectedDates[1]));
      });
    });

    final monthsInputToBeExpected = {
      -10: [ColignyCalendar(5019, 13, 29, true), ColignyCalendar(5019, 12, 28)],
      -1: [ColignyCalendar(5020, 9, 29, true), ColignyCalendar(5020, 9, 28)],
      1: [ColignyCalendar(5020, 11, 29, true), ColignyCalendar(5020, 11, 28)],
      3: [ColignyCalendar(5021, 1, 29, true), ColignyCalendar(5020, 13, 28)],
      13: [ColignyCalendar(5021, 11, 29, true), ColignyCalendar(5021, 10, 28)]
    };

    monthsInputToBeExpected.forEach((monthsToAdd, expectedDates) {
      test('will add $monthsToAdd months correctly', () {
        expect(metonicTestStartDate.addMonths(monthsToAdd),
            equals(expectedDates[0]));
        expect(saturnTestStartDate.addMonths(monthsToAdd),
            equals(expectedDates[1]));
      });
    });

    final yearsInputToBeExpected = {
      -5: [ColignyCalendar(5015, 10, 29, true), ColignyCalendar(5015, 10, 28)],
      1: [ColignyCalendar(5021, 10, 29, true), ColignyCalendar(5021, 10, 28)],
      10: [ColignyCalendar(5030, 10, 29, true), ColignyCalendar(5030, 10, 28)]
    };

    yearsInputToBeExpected.forEach((yearsToAdd, expectedDates) {
      test('will add $yearsToAdd years correctly', () {
        expect(metonicTestStartDate.addYears(yearsToAdd),
            equals(expectedDates[0]));
        expect(
            saturnTestStartDate.addYears(yearsToAdd), equals(expectedDates[1]));
      });
    });
  });

  group('Coligny Month', () {
    final inputsToBeExpected = {
      29: 'ANM',
      30: 'MAT',
    };

    inputsToBeExpected.forEach((input, expected) {
      test('$input should produce $expected as omen', () {
        expect(ColignyMonth('test', input).omen, equals(expected));
      });
    });

    test('it throws an error if the days are wrong', () {
      expect(() => ColignyMonth('test', 28), throwsRangeError);
    });
  });

  group('Coligny Year (metonic)', () {
    final inputsToBeExpected = {
      5019: [
        // ident 3
        384,
        {
          'Samonios': 'MAT',
          'Dumanios': 'ANM',
          'Riuros': 'MAT',
          'Anagantios': 'ANM',
          'Ogronios': 'MAT',
          'Cutios': 'MAT',
          'Rantaranos': 'MAT',
          'Giamonios': 'ANM',
          'Simiuisonna': 'MAT',
          'Equos': 'ANM',
          'Elembi': 'ANM',
          'Aedrinni': 'MAT',
          'Cantlos': 'ANM'
        }
      ],
      5020: [
        // ident 4
        354,
        {
          'Samonios': 'MAT',
          'Dumanios': 'ANM',
          'Riuros': 'MAT',
          'Anagantios': 'ANM',
          'Ogronios': 'MAT',
          'Cutios': 'MAT',
          'Giamonios': 'ANM',
          'Simiuisonna': 'MAT',
          'Equos': 'ANM',
          'Elembi': 'ANM',
          'Aedrinni': 'MAT',
          'Cantlos': 'ANM'
        }
      ],
      5021: [
        // ident 5
        355,
        {
          'Samonios': 'MAT',
          'Dumanios': 'ANM',
          'Riuros': 'MAT',
          'Anagantios': 'ANM',
          'Ogronios': 'MAT',
          'Cutios': 'MAT',
          'Giamonios': 'ANM',
          'Simiuisonna': 'MAT',
          'Equos': 'MAT',
          'Elembi': 'ANM',
          'Aedrinni': 'MAT',
          'Cantlos': 'ANM'
        }
      ],
      5022: [
        // ident 1
        384,
        {
          'Quimonios': 'ANM',
          'Samonios': 'MAT',
          'Dumanios': 'ANM',
          'Riuros': 'MAT',
          'Anagantios': 'ANM',
          'Ogronios': 'MAT',
          'Cutios': 'MAT',
          'Giamonios': 'ANM',
          'Equos': 'MAT',
          'Simiuisonna': 'MAT',
          'Elembi': 'ANM',
          'Aedrinni': 'MAT',
          'Cantlos': 'ANM'
        }
      ],
      5064: [
        // ident 5 60 years out
        354,
        {
          'Samonios': 'MAT',
          'Dumanios': 'ANM',
          'Riuros': 'MAT',
          'Anagantios': 'ANM',
          'Ogronios': 'MAT',
          'Cutios': 'MAT',
          'Giamonios': 'ANM',
          'Simiuisonna': 'MAT',
          'Equos': 'ANM',
          'Elembi': 'ANM',
          'Aedrinni': 'MAT',
          'Cantlos': 'ANM'
        }
      ],
      11570: [
        // ident 3 6.5k years out
        354,
        {
          'Samonios': 'MAT',
          'Dumanios': 'ANM',
          'Riuros': 'MAT',
          'Anagantios': 'ANM',
          'Ogronios': 'MAT',
          'Cutios': 'MAT',
          'Giamonios': 'ANM',
          'Simiuisonna': 'MAT',
          'Equos': 'ANM',
          'Elembi': 'ANM',
          'Aedrinni': 'MAT',
          'Cantlos': 'ANM'
        }
      ]
    };

    inputsToBeExpected.forEach((year, expectedValues) {
      int expectedLength = expectedValues[0];
      Map<String, String> expectedMonthsInOrder = expectedValues[1];

      test('the year $year should right length with right months', () {
        final testYear = ColignyYear(year, true);
        expect(testYear.daysInYear, equals(expectedLength));
        expect(testYear.months.length, equals(expectedMonthsInOrder.length));
        for (int i = 0; i < testYear.months.length; i++) {
          final testMonth = testYear.months[i];
          final expected = expectedMonthsInOrder.entries.elementAt(i);
          expect(testMonth.name, equals(expected.key));
          expect(testMonth.omen, equals(expected.value));
        }
      });
    });
  });

  group('Coligny Year (saturn)', () {
    final inputsToBeExpected = {
      5017: [
        // ident 5
        355,
        {
          'Samonios': 'MAT',
          'Dumanios': 'ANM',
          'Riuros': 'MAT',
          'Anagantios': 'ANM',
          'Ogronios': 'MAT',
          'Cutios': 'MAT',
          'Giamonios': 'ANM',
          'Simiuisonna': 'MAT',
          'Equos': 'MAT',
          'Elembi': 'ANM',
          'Aedrinni': 'MAT',
          'Cantlos': 'ANM'
        }
      ],
      5018: [
        // ident 1
        384,
        {
          'Quimonios': 'ANM',
          'Samonios': 'MAT',
          'Dumanios': 'ANM',
          'Riuros': 'MAT',
          'Anagantios': 'ANM',
          'Ogronios': 'MAT',
          'Cutios': 'MAT',
          'Giamonios': 'ANM',
          'Equos': 'MAT',
          'Simiuisonna': 'MAT',
          'Elembi': 'ANM',
          'Aedrinni': 'MAT',
          'Cantlos': 'ANM'
        }
      ],
      5019: [
        // ident 2
        354,
        {
          'Samonios': 'MAT',
          'Dumanios': 'ANM',
          'Riuros': 'MAT',
          'Anagantios': 'ANM',
          'Ogronios': 'MAT',
          'Cutios': 'MAT',
          'Giamonios': 'ANM',
          'Simiuisonna': 'MAT',
          'Equos': 'ANM',
          'Elembi': 'ANM',
          'Aedrinni': 'MAT',
          'Cantlos': 'ANM'
        }
      ],
      5020: [
        // ident 3 - not year 27
        384,
        {
          'Samonios': 'MAT',
          'Dumanios': 'ANM',
          'Riuros': 'MAT',
          'Anagantios': 'ANM',
          'Ogronios': 'MAT',
          'Cutios': 'MAT',
          'Rantaranos': 'MAT',
          'Giamonios': 'ANM',
          'Simiuisonna': 'MAT',
          'Equos': 'ANM',
          'Elembi': 'ANM',
          'Aedrinni': 'MAT',
          'Cantlos': 'ANM'
        }
      ],
      5197: [
        // ident 5 - but short equos
        354,
        {
          'Samonios': 'MAT',
          'Dumanios': 'ANM',
          'Riuros': 'MAT',
          'Anagantios': 'ANM',
          'Ogronios': 'MAT',
          'Cutios': 'MAT',
          'Giamonios': 'ANM',
          'Simiuisonna': 'MAT',
          'Equos': 'ANM',
          'Elembi': 'ANM',
          'Aedrinni': 'MAT',
          'Cantlos': 'ANM'
        }
      ],
      5025: [
        // ident 3 - year 27, not far future year
        354,
        {
          'Samonios': 'MAT',
          'Dumanios': 'ANM',
          'Riuros': 'MAT',
          'Anagantios': 'ANM',
          'Ogronios': 'MAT',
          'Cutios': 'MAT',
          'Giamonios': 'ANM',
          'Simiuisonna': 'MAT',
          'Equos': 'ANM',
          'Elembi': 'ANM',
          'Aedrinni': 'MAT',
          'Cantlos': 'ANM'
        }
      ],
      5655: [
        // ident 3 - year 27, also the magical far future year
        384,
        {
          'Samonios': 'MAT',
          'Dumanios': 'ANM',
          'Riuros': 'MAT',
          'Anagantios': 'ANM',
          'Ogronios': 'MAT',
          'Cutios': 'MAT',
          'Rantaranos': 'MAT',
          'Giamonios': 'ANM',
          'Simiuisonna': 'MAT',
          'Equos': 'ANM',
          'Elembi': 'ANM',
          'Aedrinni': 'MAT',
          'Cantlos': 'ANM'
        }
      ]
    };

    inputsToBeExpected.forEach((year, expectedValues) {
      int expectedLength = expectedValues[0];
      Map<String, String> expectedMonthsInOrder = expectedValues[1];

      test('the year $year should right length with right months', () {
        final testYear = ColignyYear(year, false);
        expect(testYear.daysInYear, equals(expectedLength));
        expect(testYear.months.length, equals(expectedMonthsInOrder.length));
        for (int i = 0; i < testYear.months.length; i++) {
          final testMonth = testYear.months[i];
          final expected = expectedMonthsInOrder.entries.elementAt(i);
          expect(testMonth.name, equals(expected.key));
          expect(testMonth.omen, equals(expected.value));
        }
      });
    });
  });
}
