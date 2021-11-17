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
}
