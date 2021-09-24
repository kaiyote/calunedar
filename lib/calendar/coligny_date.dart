import 'package:dart_date/dart_date.dart';

import 'src/coligny_inscriptions.dart';
import 'src/coligny_month.dart';
import 'src/coligny_year.dart';

class ColignyDate {
  final int _year;
  int _day;
  final bool _metonic;
  late ColignyYear _fullYear;
  late ColignyMonth _month;

  ColignyDate(
    this._year, [
    int month = 1,
    this._day = 1,
    this._metonic = false,
  ]) {
    if (year < 0) throw RangeError('Year must be positive');

    _fullYear = ColignyYear(_year, _metonic);
    if (month < 0 || month > _fullYear.months.length) {
      throw RangeError("Invalid Month");
    } else {
      _month = _fullYear.months[month - 1];
    }
  }

  ColignyDate addDays(int days) {
    var output = copy();
    output._day += days;

    while (output.day > output._month.days) {
      if (output._month.index == output._fullYear.months.length - 1) {
        output = ColignyDate(output.year + 1, 1,
            output.day - output._month.days, output._metonic);
      } else {
        output = ColignyDate(output.year, output.month + 1,
            output.day - output._month.days, output._metonic);
      }
    }

    while (output.day < 1) {
      if (output.month == 1) {
        var newMonthLength =
            ColignyYear(output.year - 1, output._metonic).months.length;
        output = ColignyDate(output.year - 1, newMonthLength - 1,
            output.day + output._month.days, output._metonic);
      } else {
        output = ColignyDate(output.year, output.month - 1,
            output.day + output._month.days, output._metonic);
      }
    }

    return output;
  }

  ColignyDate firstDayOfMonth() {
    return ColignyDate(year, month, 1, metonic);
  }

  ColignyDate lastDayOfMonth() {
    return ColignyDate(year, month, _month.days, metonic);
  }

  ColignyDate firstDayOfYear() {
    return ColignyDate(year, 1, 1, metonic);
  }

  ColignyDate lastDayOfYear() {
    return ColignyDate(
      year,
      _fullYear.months.length,
      _fullYear.months.last.days,
      metonic,
    );
  }

  int compareTo(ColignyDate other) {
    if (_metonic != other._metonic) {
      throw ArgumentError("other must be same cycle as this");
    }

    if (this == other) return 0;
    if (year != other.year) return year < other.year ? -1 : 1;
    if (month != other.month) return month < other.month ? -1 : 1;
    if (day != other.day) return day < other.day ? -1 : 1;
    return 0;
  }

  ColignyDate copy() {
    return ColignyDate(year, month, day, metonic);
  }

  @override
  bool operator ==(Object other) {
    return other is ColignyDate &&
        year == other.year &&
        month == other.month &&
        day == other.day &&
        metonic == other.metonic;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + year.hashCode;
    result = 37 * result + month.hashCode;
    result = 37 * result + day.hashCode;
    result = 37 * result + metonic.hashCode;
    return result;
  }

  @override
  String toString() {
    return toIS08601String() + " metonic: $_metonic";
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

  String get monthName => _month.name;

  int get monthLength => _month.days;

  List<String> get inscription =>
      colignyInscriptions[monthName]![_fullYear.ident - 1][day - 1];

  int _differenceInDays(ColignyDate target) {
    if (metonic != target.metonic) {
      throw ArgumentError("Cannot diff between different cycles");
    } else if (year == target.year) {
      return (dayOfYear - target.dayOfYear).abs();
    } else if (target.compareTo(this) < 0) {
      return target._differenceInDays(this);
    } else {
      int count = yearLength - dayOfYear + target.dayOfYear;

      for (int i = year + 1; i < target.year; i++) {
        ColignyYear current = ColignyYear(i, metonic);
        count += current.daysInYear;
      }

      return count.abs();
    }
  }

  DateTime toDateTime() {
    DateTime gregorianStart;
    ColignyDate colignyStart;

    if (metonic) {
      gregorianStart = DateTime(1999, 5, 22);
      colignyStart = ColignyDate(4999, 1, 1, true);
    } else {
      gregorianStart = DateTime(1998, 5, 3);
      colignyStart = ColignyDate(4998, 1, 1);
    }

    var daysBetween = _differenceInDays(colignyStart);

    if (compareTo(colignyStart) < 0) {
      return gregorianStart.addDays(-daysBetween, true);
    } else {
      return gregorianStart.addDays(daysBetween, true);
    }
  }

  String toIS08601String() {
    final paddedYear = year.toString().padLeft(4, '0');
    final paddedMonth = month.toString().padLeft(2, '0');
    final paddedDay = day.toString().padLeft(2, '0');
    return "$paddedYear-$paddedMonth-$paddedDay";
  }

  int toInt() => year * 10000 + month * 100 + day;

  int get year => _year;

  int get yearLength => _fullYear.daysInYear;

  bool get metonic => _metonic;

  static ColignyDate fromDateTime(DateTime dt, [bool metonic = false]) {
    ColignyDate output;
    int diffInDays = 0;

    if (metonic) {
      diffInDays += dt.differenceInDays(DateTime(1999, 5, 22));
      output = ColignyDate(4999, 1, 1, true);
    } else {
      diffInDays += dt.differenceInDays(DateTime(1998, 5, 3));
      output = ColignyDate(4998, 1, 1);
    }

    return output.addDays(diffInDays);
  }

  static ColignyDate now([bool metonic = false]) {
    return ColignyDate.fromDateTime(DateTime.now(), metonic);
  }
}
