import 'package:calunedar/celestial_math/julian.dart';
import 'package:calunedar/celestial_math/moon_phase.dart';
import 'package:geolocator/geolocator.dart';
import 'package:solar_calculator/solar_calculator.dart';
import 'package:dart_date/dart_date.dart';

Instant _getInstantNearestHourAngle(
    Position position, Instant bestGuess, HourAngle target) {
  final calc =
      SolarCalculator(bestGuess, position.latitude, position.longitude);

  // degrees / 15 => archours * 60 => arcminutes / 4 => rough estimate of real days we need to travel
  var diffInDays = (target.decimalDegrees -
          calc.sunEquatorialPosition.rightAscension.decimalDegrees) /
      15 *
      60 /
      4;

  final updatedGuess =
      bestGuess.add(Duration(seconds: (diffInDays * 24 * 60 * 60).floor()));
  final updatedCalc =
      SolarCalculator(updatedGuess, position.latitude, position.longitude);

  // gets me w/in ~6 minutes of the true event
  if ((target.decimalDegrees -
              updatedCalc.sunEquatorialPosition.rightAscension.decimalDegrees)
          .abs() <
      0.001) {
    // good enough
    return updatedGuess;
  } else {
    return _getInstantNearestHourAngle(position, updatedGuess, target);
  }
}

double _dateToYearFraction(DateTime date) {
  final daysBetween = date.differenceInDays(date.startOfYear);
  return date.year + (daysBetween / 356.25);
}

///
/// These are named by month instead of season so that the code makes sense even
/// for people in the southern hemisphere. I'm not going to tackle shifting the
/// year by ~6 months just because your seasons are different.
///

Instant marchEquinox(Position position, int year) {
  final initialGuess = Instant.fromDateTime(DateTime(year, 3, 20));

  return _getInstantNearestHourAngle(
      position, initialGuess, HourAngle.fromDegrees(359.999)); // oddities w/ 0
}

Instant juneSolstice(Position position, int year) {
  final initialGuess = Instant.fromDateTime(DateTime(year, 6, 20));

  return _getInstantNearestHourAngle(
      position, initialGuess, HourAngle.fromDegrees(90));
}

Instant septemberEquinox(Position position, int year) {
  final initialGuess = Instant.fromDateTime(DateTime(year, 9, 22));

  return _getInstantNearestHourAngle(
      position, initialGuess, HourAngle.fromDegrees(180));
}

Instant decemberSolstice(Position position, int year) {
  final initialGuess = Instant.fromDateTime(DateTime(year, 12, 21));

  return _getInstantNearestHourAngle(
      position, initialGuess, HourAngle.fromDegrees(270));
}

List<DateTime> visibleNewMoonsForYear(
  Instant start,
  Instant end,
  Position position, [
  int offset = 2,
]) {
  final startDateTime = start.toUtcDateTime().startOfDay;
  final startMoon = Iterable.generate(2, _generateMoon(startDateTime))
      .where((element) => element.isSameOrAfter(startDateTime))
      .first;

  final endDateTime = end.toUtcDateTime().startOfDay;
  final endMoon = Iterable.generate(2, _generateMoon(endDateTime))
      .where((element) => element.isSameOrAfter(endDateTime))
      .first;

  final newMoons = Iterable.generate(14, _generateMoon(startMoon)).where(
      (element) =>
          element.isSameOrAfter(startMoon) && element.isSameOrBefore(endMoon));

  return newMoons
      .map((e) => e.startOfDay.addDays(offset).startOfDay)
      .toSet()
      .toList();
}

DateTime Function(int i) _generateMoon(DateTime startDate) {
  return (i) {
    final testDate = startDate.addDays(29 * i).addHours(12 * i);
    return jdToDateTime(newMoon(_dateToYearFraction(testDate)));
  };
}
