import 'package:calunedar/calendar/src/attic_month.dart';
import 'package:calunedar/calendar/src/attic_year.dart';
import 'package:dart_date/dart_date.dart';

class AtticDate {
  final int _year;
  int _day;
  late AtticYear _fullYear;
  late AtticMonth _month;

  AtticDate(
    this._year, [
    int month = 1,
    this._day = 1,
  ]) {
    if (year < 0) throw RangeError('Year must be positive');

    _fullYear = AtticYear(_year);
    if (month < 0 || month > _fullYear.months.length) {
      throw RangeError("Invalid Month");
    } else {
      _month = _fullYear.months[month - 1];
    }
  }

  int get day => _day;

  int get dayOfYear {
    int dayOfYear = _day;

    for (int i = 0; i < _month.index; i++) {
      dayOfYear += _fullYear.months[i].days;
    }

    return dayOfYear;
  }

  int get month => _month.index + 1;

  String monthName([useGreekName = false]) =>
      useGreekName ? _month.greekName : _month.name;

  String get greekMonthName => _month.greekName;

  int get monthLength => _month.days;

  String toIS08601String() {
    final paddedYear = year.toString().padLeft(4, '0');
    final paddedMonth = month.toString().padLeft(2, '0');
    final paddedDay = day.toString().padLeft(2, '0');
    return "$paddedYear-$paddedMonth-$paddedDay";
  }

  int toInt() => year * 10000 + month * 100 + day;

  int get year => _year;

  int get yearLength => _fullYear.daysInYear;

  int compareTo(AtticDate other) {
    if (this == other) return 0;
    if (year != other.year) return year < other.year ? -1 : 1;
    if (month != other.month) return month < other.month ? -1 : 1;
    if (day != other.day) return day < other.day ? -1 : 1;
    return 0;
  }

  AtticDate copy() {
    return AtticDate(year, month, day);
  }

  @override
  bool operator ==(Object other) {
    return other is AtticDate &&
        year == other.year &&
        month == other.month &&
        day == other.day;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + year.hashCode;
    result = 37 * result + month.hashCode;
    result = 37 * result + day.hashCode;
    return result;
  }

  @override
  String toString() {
    return toIS08601String();
  }

  AtticDate firstDayOfMonth() {
    return AtticDate(year, month, 1);
  }

  AtticDate lastDayOfMonth() {
    return AtticDate(year, month, _month.days);
  }

  AtticDate firstDayOfYear() {
    return AtticDate(year, 1, 1);
  }

  AtticDate lastDayOfYear() {
    return AtticDate(
      year,
      _fullYear.months.length,
      _fullYear.months.last.days,
    );
  }

  AtticDate addDays(int days) {
    var output = copy();
    output._day += days;

    while (output.day > output._month.days) {
      if (output._month.index == output._fullYear.months.length - 1) {
        output = AtticDate(output.year + 1, 1, output.day - output._month.days);
      } else {
        output = AtticDate(
            output.year, output.month + 1, output.day - output._month.days);
      }
    }

    while (output.day < 1) {
      if (output.month == 1) {
        var newMonthLength = AtticYear(output.year - 1).months.length;
        output = AtticDate(output.year - 1, newMonthLength - 1,
            output.day + output._month.days);
      } else {
        output = AtticDate(
            output.year, output.month - 1, output.day + output._month.days);
      }
    }

    return output;
  }

  int _differenceInDays(AtticDate target) {
    if (year == target.year) {
      return (dayOfYear - target.dayOfYear).abs();
    } else if (target.compareTo(this) < 0) {
      return target._differenceInDays(this);
    } else {
      int count = yearLength - dayOfYear + target.dayOfYear;

      for (int i = year + 1; i < target.year; i++) {
        AtticYear current = AtticYear(i);
        count += current.daysInYear;
      }

      return count.abs();
    }
  }

  // TODO
  DateTime toDateTime() {
    throw Exception('Not Implemented');
  }

  // TODO
  static AtticDate fromDateTime(DateTime dt) {
    AtticDate output;
    int diffInDays = 0;

    // so very wrong
    diffInDays += dt.differenceInDays(DateTime(1998, 5, 3));
    output = AtticDate(1, 1, 1);

    return output.addDays(diffInDays);
  }

  static AtticDate now() {
    return AtticDate.fromDateTime(DateTime.now());
  }
}
