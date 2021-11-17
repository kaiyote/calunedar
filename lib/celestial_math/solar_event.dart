import 'package:geolocator/geolocator.dart';
import 'package:solar_calculator/solar_calculator.dart';

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
