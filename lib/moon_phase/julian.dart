// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

/// Returns the integer floor of the fractional value (x / y).
///
/// It uses integer math only, so is more efficient than using floating point
/// intermediate values.  This function can be used in many places where INT()
/// appears in AA.  As with built in integer division, it panics with y == 0.
int _floorDiv(int x, y) {
  var q = x ~/ y;
  if ((x < 0) != (y < 0) && x % y != 0) {
    q--;
  }
  return q;
}

/// Modf returns integer and fractional floating-point numbers
/// that sum to f. Both values have the same sign as f.
_ModfResult _modf(num v) {
  final a = v.truncate();
  final b = v - a;
  return _ModfResult(a, b);
}

/// Integer and fractional floating-point numbers that sum to some value.
class _ModfResult {
  /// Integer part
  final int intPart;

  /// Fractional part
  final num fracPart;

  const _ModfResult(this.intPart, this.fracPart);
}

class _Calendar {
  final int year;
  final int month;
  final num day;

  const _Calendar(this.year, this.month, this.day);
}

_Calendar _jdToCalendarGregorian(num jd) {
  final modfResult = _modf(jd + .5);
  final z = modfResult.intPart;
  final alpha = _floorDiv(z * 100 - 186721625, 3652425);
  final a = z + 1 + alpha - _floorDiv(alpha, 4);
  final b = a + 1524;
  final c = _floorDiv(b * 100 - 12210, 36525);
  final d = _floorDiv(36525 * c, 100);
  final e = _floorDiv(((b - d) * 1e4).truncate(), 306001);
  // compute return values
  final day = ((b - d) - _floorDiv(306001 * e, 1e4)) + modfResult.fracPart;
  var month, year;
  switch (e) {
    case 14:
    case 15:
      month = e - 13;
      break;
    default:
      month = e - 1;
  }
  switch (month) {
    case 1:
    case 2:
      year = c - 4715;
      break;
    default:
      year = c - 4716;
  }
  return _Calendar(year, month, day);
}

/// Takes a JD and returns a Dart DateTime value.
DateTime jdToDateTime(num jd) {
  // DateTime is always Gregorian
  final cal = _jdToCalendarGregorian(jd);
  final dt = DateTime.utc(cal.year, cal.month, 0, 0, 0, 0, 0);
  return dt.add(
      Duration(seconds: (cal.day * 24 * Duration.secondsPerHour).truncate()));
}
