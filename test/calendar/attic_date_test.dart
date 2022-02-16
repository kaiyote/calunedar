import 'package:calunedar/calendar/attic_date.dart';
import 'package:calunedar/calendar/src/attic_month.dart';
import 'package:calunedar/calendar/src/attic_year.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

// vaguely Eastern Time Zone
const latitude = 44.799565;
const longitude = -82.420758;

final northernHemisphere = Position(
  latitude: latitude,
  longitude: longitude,
  timestamp: DateTime.now(),
  accuracy: 0.0,
  altitude: 0.0,
  heading: 0.0,
  speed: 0.0,
  speedAccuracy: 0.0,
);

void assertMonth(AtticMonth month, int days, String name, String greekName) {
  expect(month.days, equals(days));
  expect(month.name, equals(name));
  expect(month.greekName, equals(greekName));
}

void main() {
  group('attic year tests', () {
    test('Attic Year for 2022/2023 makes sense', () {
      final result = AtticYear(2022, northernHemisphere);

      expect(result.daysInYear, equals(383));
      expect(result.months.length, equals(13));

      assertMonth(result.months[0], 29, "Hekatombaiṓn", "Ἑκατομβαιών");
      assertMonth(result.months[1], 30, "Metageitniṓn", "Μεταγειτνιών");
      assertMonth(result.months[2], 29, "Boēdromiṓn", "Βοηδρομιών");
      assertMonth(result.months[3], 30, "Puanopsiṓn", "Πυανοψιών");
      assertMonth(result.months[4], 30, "Maimaktēriṓn", "Μαιμακτηριών");
      assertMonth(result.months[5], 29, "Posideiṓn", "Ποσιδειών");
      assertMonth(
        result.months[6],
        29,
        "Posideiṓn hústeros",
        "Ποσιδειών ὕστερος",
      );
      assertMonth(result.months[7], 30, "Gamēliṓn", "Γαμηλιών");
      assertMonth(result.months[8], 29, "Anthestēriṓn", "Ἀνθεστηριών");
      assertMonth(result.months[9], 30, "Elaphēboliṓn", "Ἑλαφηβολιών");
      assertMonth(result.months[10], 29, "Mounuchiṓn", "Μουνυχιών");
      assertMonth(result.months[11], 30, "Thargēliṓn", "Θαργηλιών");
      assertMonth(result.months[12], 29, "Skirophoriṓn", "Σκιροφοριών");
    });
  });

  group('gregorian to attic', () {
    test('2/15/2022 is 8/14/(2021/2022)', () {
      final result =
          AtticDate.fromDateTime(DateTime(2022, 2, 15), northernHemisphere);

      expect(result.month, equals(8));
      expect(result.monthName, equals("Anthestēriṓn"));
      expect(result.day, equals(13));
      // i really need to do something about this
      expect(result.year, equals(2021));
    });
  });
}
