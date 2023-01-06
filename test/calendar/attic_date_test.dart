import 'package:calunedar/calendar/attic_date.dart';
import 'package:calunedar/calendar/src/attic_month.dart';
import 'package:calunedar/calendar/src/attic_year.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

// vaguely Eastern Time Zone
const latitude = 44.799565;
const longitude = -82.420758;

final position = Position(
  latitude: latitude,
  longitude: longitude,
  timestamp: DateTime.now(),
  accuracy: 0.0,
  altitude: 0.0,
  heading: 0.0,
  speed: 0.0,
  speedAccuracy: 0.0,
);

void assertMonth(AtticMonth month, int days, String name, String greekName,
    DateTime startGregorian) {
  expect(month.days, equals(days));
  expect(month.name, equals(name));
  expect(month.greekName, equals(greekName));
  expect(month.startGregorian, equals(startGregorian));
}

void main() {
  group('attic year tests', () {
    test('Attic Year for 2021/2022 makes sense', () {
      final result = AtticYear(2021);

      expect(result.daysInYear, equals(354));
      expect(result.months.length, equals(12));

      assertMonth(result.months[0], 29, "Hekatombaiṓn", "Ἑκατομβαιών",
          DateTime(2021, 7, 12));
      assertMonth(result.months[1], 30, "Metageitniṓn", "Μεταγειτνιών",
          DateTime(2021, 8, 10));
      assertMonth(result.months[2], 29, "Boēdromiṓn", "Βοηδρομιών",
          DateTime(2021, 9, 9));
      assertMonth(result.months[3], 29, "Puanopsiṓn", "Πυανοψιών",
          DateTime(2021, 10, 8));
      assertMonth(result.months[4], 30, "Maimaktēriṓn", "Μαιμακτηριών",
          DateTime(2021, 11, 6));
      assertMonth(result.months[5], 29, "Posideiṓn", "Ποσιδειών",
          DateTime(2021, 12, 6));
      assertMonth(
          result.months[6], 30, "Gamēliṓn", "Γαμηλιών", DateTime(2022, 1, 4));
      assertMonth(result.months[7], 29, "Anthestēriṓn", "Ἀνθεστηριών",
          DateTime(2022, 2, 3));
      assertMonth(result.months[8], 30, "Elaphēboliṓn", "Ἑλαφηβολιών",
          DateTime(2022, 3, 4));
      assertMonth(result.months[9], 29, "Mounuchiṓn", "Μουνυχιών",
          DateTime(2022, 4, 3));
      assertMonth(result.months[10], 30, "Thargēliṓn", "Θαργηλιών",
          DateTime(2022, 5, 2));
      assertMonth(result.months[11], 30, "Skirophoriṓn", "Σκιροφοριών",
          DateTime(2022, 6, 1));
    });

    test('Attic Year for 2022/2023 makes sense', () {
      final result = AtticYear(2022);

      expect(result.daysInYear, equals(383));
      expect(result.months.length, equals(13));

      assertMonth(result.months[0], 29, "Hekatombaiṓn", "Ἑκατομβαιών",
          DateTime(2022, 7, 1));
      assertMonth(result.months[1], 30, "Metageitniṓn", "Μεταγειτνιών",
          DateTime(2022, 7, 30));
      assertMonth(result.months[2], 29, "Boēdromiṓn", "Βοηδρομιών",
          DateTime(2022, 8, 29));
      assertMonth(result.months[3], 30, "Puanopsiṓn", "Πυανοψιών",
          DateTime(2022, 9, 27));
      assertMonth(result.months[4], 29, "Maimaktēriṓn", "Μαιμακτηριών",
          DateTime(2022, 10, 27));
      assertMonth(result.months[5], 30, "Posideiṓn", "Ποσιδειών",
          DateTime(2022, 11, 25));
      assertMonth(
        result.months[6],
        29,
        "Posideiṓn hústeros",
        "Ποσιδειών ὕστερος",
        DateTime(2022, 12, 25),
      );
      assertMonth(
          result.months[7], 30, "Gamēliṓn", "Γαμηλιών", DateTime(2023, 1, 23));
      assertMonth(result.months[8], 29, "Anthestēriṓn", "Ἀνθεστηριών",
          DateTime(2023, 2, 22));
      assertMonth(result.months[9], 30, "Elaphēboliṓn", "Ἑλαφηβολιών",
          DateTime(2023, 3, 23));
      assertMonth(result.months[10], 29, "Mounuchiṓn", "Μουνυχιών",
          DateTime(2023, 4, 22));
      assertMonth(result.months[11], 30, "Thargēliṓn", "Θαργηλιών",
          DateTime(2023, 5, 21));
      assertMonth(result.months[12], 29, "Skirophoriṓn", "Σκιροφοριών",
          DateTime(2023, 6, 20));
    });

    test('Attic Year for 2023/2024 makes sense', () {
      final result = AtticYear(2023);

      expect(result.daysInYear, equals(354));
      expect(result.months.length, equals(12));

      assertMonth(result.months[0], 30, "Hekatombaiṓn", "Ἑκατομβαιών",
          DateTime(2023, 7, 19));
      assertMonth(result.months[1], 30, "Metageitniṓn", "Μεταγειτνιών",
          DateTime(2023, 8, 18));
      assertMonth(result.months[2], 29, "Boēdromiṓn", "Βοηδρομιών",
          DateTime(2023, 9, 17));
      assertMonth(result.months[3], 30, "Puanopsiṓn", "Πυανοψιών",
          DateTime(2023, 10, 16));
      assertMonth(result.months[4], 29, "Maimaktēriṓn", "Μαιμακτηριών",
          DateTime(2023, 11, 15));
      assertMonth(result.months[5], 30, "Posideiṓn", "Ποσιδειών",
          DateTime(2023, 12, 14));
      assertMonth(
          result.months[6], 29, "Gamēliṓn", "Γαμηλιών", DateTime(2024, 1, 13));
      assertMonth(result.months[7], 30, "Anthestēriṓn", "Ἀνθεστηριών",
          DateTime(2024, 2, 11));
      assertMonth(result.months[8], 29, "Elaphēboliṓn", "Ἑλαφηβολιών",
          DateTime(2024, 3, 12));
      assertMonth(result.months[9], 30, "Mounuchiṓn", "Μουνυχιών",
          DateTime(2024, 4, 10));
      assertMonth(result.months[10], 29, "Thargēliṓn", "Θαργηλιών",
          DateTime(2024, 5, 10));
      assertMonth(result.months[11], 29, "Skirophoriṓn", "Σκιροφοριών",
          DateTime(2024, 6, 8));
    });
  });

  group('gregorian to attic', () {
    test('2/15/2022 is 8/14/(2021/2022)', () {
      final result = AtticDate.fromDateTime(DateTime(2022, 2, 15));

      expect(result.month, equals(8));
      expect(result.monthName, equals("Anthestēriṓn"));
      expect(result.day, equals(13));
      expect(result.year, equals(2021));
    });

    test('6/26/2022 is 12/26/(2021/2022)', () {
      final result = AtticDate.fromDateTime(DateTime(2022, 6, 26));

      expect(result.month, equals(12));
      expect(result.monthName, equals("Skirophoriṓn"));
      expect(result.day, equals(26));
      expect(result.year, equals(2021));
    });
  });
}
