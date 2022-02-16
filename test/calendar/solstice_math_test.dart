import 'package:calunedar/calendar/attic_date.dart';
import 'package:calunedar/celestial_math/solar_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:solar_calculator/solar_calculator.dart';

const maxAllowableDifference = 6;

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

final southernHemisphere = Position(
  latitude: -latitude,
  longitude: longitude,
  timestamp: DateTime.now(),
  accuracy: 0.0,
  altitude: 0.0,
  heading: 0.0,
  speed: 0.0,
  speedAccuracy: 0.0,
);

void main() {
  test('march equinox', () {
    expect(
        marchEquinox(northernHemisphere, 2021).sinceEpoch.inMinutes,
        closeTo(
            Instant(
                    year: 2021,
                    month: 3,
                    day: 20,
                    hour: 5,
                    minute: 37,
                    timeZoneOffset: -4)
                .sinceEpoch
                .inMinutes,
            maxAllowableDifference));

    expect(
        marchEquinox(southernHemisphere, 2021).sinceEpoch.inMinutes,
        closeTo(
            Instant(
                    year: 2021,
                    month: 3,
                    day: 20,
                    hour: 5,
                    minute: 37,
                    timeZoneOffset: -4)
                .sinceEpoch
                .inMinutes,
            maxAllowableDifference));
  });

  test('june solstice', () {
    expect(
        juneSolstice(northernHemisphere, 2021).sinceEpoch.inMinutes,
        closeTo(
            Instant(
                    year: 2021,
                    month: 6,
                    day: 20,
                    hour: 23,
                    minute: 31,
                    timeZoneOffset: -4)
                .sinceEpoch
                .inMinutes,
            maxAllowableDifference));

    expect(
        juneSolstice(southernHemisphere, 2021).sinceEpoch.inMinutes,
        closeTo(
            Instant(
                    year: 2021,
                    month: 6,
                    day: 20,
                    hour: 23,
                    minute: 31,
                    timeZoneOffset: -4)
                .sinceEpoch
                .inMinutes,
            maxAllowableDifference));
  });

  test('september equinox', () {
    expect(
        septemberEquinox(northernHemisphere, 2021).sinceEpoch.inMinutes,
        closeTo(
            Instant(
                    year: 2021,
                    month: 9,
                    day: 22,
                    hour: 15,
                    minute: 20,
                    timeZoneOffset: -4)
                .sinceEpoch
                .inMinutes,
            maxAllowableDifference));

    expect(
        septemberEquinox(southernHemisphere, 2021).sinceEpoch.inMinutes,
        closeTo(
            Instant(
                    year: 2021,
                    month: 9,
                    day: 22,
                    hour: 15,
                    minute: 20,
                    timeZoneOffset: -4)
                .sinceEpoch
                .inMinutes,
            maxAllowableDifference));
  });

  test('december solstice', () {
    expect(
        decemberSolstice(northernHemisphere, 2021).sinceEpoch.inMinutes,
        closeTo(
            Instant(
                    year: 2021,
                    month: 12,
                    day: 21,
                    hour: 10,
                    minute: 58,
                    timeZoneOffset: -5)
                .sinceEpoch
                .inMinutes,
            maxAllowableDifference));

    expect(
        decemberSolstice(southernHemisphere, 2021).sinceEpoch.inMinutes,
        closeTo(
            Instant(
                    year: 2021,
                    month: 12,
                    day: 21,
                    hour: 10,
                    minute: 58,
                    timeZoneOffset: -5)
                .sinceEpoch
                .inMinutes,
            maxAllowableDifference));
  });

  test('visible moons between two instants for attic year starting in 2021',
      () {
    final start = juneSolstice(athens, 2021);
    final end = juneSolstice(athens, 2022);
    final result = visibleNewMoonsForYear(start, end, athens);

    // its one longer than the number of months, since we need the moon after the end for month length
    expect(result.length, equals(13));

    expect(result[0], equals(DateTime(2021, 7, 12)));
    expect(result[1], equals(DateTime(2021, 8, 10)));
    expect(result[2], equals(DateTime(2021, 9, 9)));
    expect(result[3], equals(DateTime(2021, 10, 8)));
    expect(result[4], equals(DateTime(2021, 11, 6)));
    expect(result[5], equals(DateTime(2021, 12, 6)));
    expect(result[6], equals(DateTime(2022, 1, 4)));
    expect(result[7], equals(DateTime(2022, 2, 3)));
    expect(result[8], equals(DateTime(2022, 3, 4)));
    expect(result[9], equals(DateTime(2022, 4, 3)));
    expect(result[10], equals(DateTime(2022, 5, 2)));
    expect(result[11], equals(DateTime(2022, 6, 1)));
  });

  test('visible moons between two instants for attic year starting in 2022',
      () {
    final start = juneSolstice(athens, 2022);
    final end = juneSolstice(athens, 2023);
    final result = visibleNewMoonsForYear(start, end, athens);

    // its one longer than the number of months, since we need the moon after the end for month length
    expect(result.length, equals(14));

    expect(result[0], equals(DateTime(2022, 7, 1)));
    expect(result[1], equals(DateTime(2022, 7, 30)));
    expect(result[2], equals(DateTime(2022, 8, 29)));
    expect(result[3], equals(DateTime(2022, 9, 27)));
    expect(result[4], equals(DateTime(2022, 10, 27)));
    expect(result[5], equals(DateTime(2022, 11, 25)));
    expect(result[6], equals(DateTime(2022, 12, 25)));
    expect(result[7], equals(DateTime(2023, 1, 23)));
    expect(result[8], equals(DateTime(2023, 2, 22)));
    expect(result[9], equals(DateTime(2023, 3, 23)));
    expect(result[10], equals(DateTime(2023, 4, 22)));
    expect(result[11], equals(DateTime(2023, 5, 21)));
    expect(result[12], equals(DateTime(2023, 6, 20)));
  });
}
