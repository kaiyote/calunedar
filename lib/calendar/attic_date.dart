import 'package:calunedar/calendar/src/attic_holidays.dart';
import 'package:calunedar/calendar/src/attic_month.dart';
import 'package:calunedar/calendar/src/attic_year.dart';
import 'package:dart_date/dart_date.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reselect/reselect.dart';
import 'package:tuple/tuple.dart';

final atticYearSelector =
    createSelector2<Tuple2<int, Position>, int, Position, AtticYear>(
  (t) => t.item1,
  (t) => t.item2,
  (year, position) => AtticYear(year, position),
);

class AtticDate {
  final int _year;
  final Position _position;
  int _day;
  late AtticYear _fullYear;
  late AtticMonth _month;

  AtticDate(
    this._position,
    this._year, [
    int month = 1,
    this._day = 1,
  ]) {
    if (year < 0) throw RangeError('Year must be positive');

    _fullYear = atticYearSelector(Tuple2(_year, _position));
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

  String get monthName => _month.name;

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

  Position get position => _position;

  int compareTo(AtticDate other) {
    if (this == other) return 0;
    if (year != other.year) return year < other.year ? -1 : 1;
    if (month != other.month) return month < other.month ? -1 : 1;
    if (day != other.day) return day < other.day ? -1 : 1;
    return 0;
  }

  AtticDate copy() {
    return AtticDate(position, year, month, day);
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
    return AtticDate(position, year, month, 1);
  }

  AtticDate lastDayOfMonth() {
    return AtticDate(position, year, month, _month.days);
  }

  AtticDate firstDayOfYear() {
    return AtticDate(position, year, 1, 1);
  }

  AtticDate lastDayOfYear() {
    return AtticDate(
      position,
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
        output = AtticDate(
          output.position,
          output.year + 1,
          1,
          output.day - output._month.days,
        );
      } else {
        output = AtticDate(
          output.position,
          output.year,
          output.month + 1,
          output.day - output._month.days,
        );
      }
    }

    while (output.day < 1) {
      if (output.month == 1) {
        var newMonthLength =
            AtticYear(output.year - 1, output.position).months.length;
        output = AtticDate(
          output.position,
          output.year - 1,
          newMonthLength,
          output.day + output._month.days,
        );
      } else {
        output = AtticDate(
          output.position,
          output.year,
          output.month - 1,
          output.day + output._month.days,
        );
      }
    }

    return output;
  }

  int differenceInDays(AtticDate target) {
    if (year == target.year) {
      return (dayOfYear - target.dayOfYear).abs();
    } else if (target.compareTo(this) < 0) {
      return target.differenceInDays(this);
    } else {
      int count = yearLength - dayOfYear + target.dayOfYear;

      for (int i = year + 1; i < target.year; i++) {
        AtticYear current = AtticYear(i, position);
        count += current.daysInYear;
      }

      return count.abs();
    }
  }

  List<String> get holidays {
    final List<String> holidays = [];

    switch (day) {
      case 1:
        holidays.add("Noumenia");
        break;
      case 2:
        holidays.add("Agathos Daimon");
        break;
      case 3:
        holidays.add("Athene");
        break;
      case 4:
        holidays.add("Aphrodite, Hermes, Herakles, Eros");
        break;
      case 6:
        holidays.add("Artemis");
        break;
      case 7:
        holidays.add("Apollon");
        break;
      case 8:
        holidays.add("Poseidon");
        break;
      case 9:
        holidays.add("Helios, the Muses and Rhea");
        break;
    }

    if (compareTo(lastDayOfMonth()) == 0) {
      holidays.add("Hekate's Deipnon");
    }

    holidays.addAll(atticHolidays[monthName]![day - 1]);

    if (monthName == "Puanopsiṓn" && day == 29 && monthLength == 30) {
      holidays.remove("Khalkeia");
    }

    return holidays;
  }

  static AtticDate fromDateTime(DateTime dt, [Position position = athens]) {
    AtticDate output = AtticDate(position, dt.year);
    if (output.firstDayOfYear()._month.startGregorian.isAfter(dt.startOfDay)) {
      output = AtticDate(position, dt.year - 1);
    }

    int diffInDays = (dt.local.startOfDay
                .difference(output._fullYear.months[0].startGregorian)
                .inHours /
            24)
        .round();

    return output.addDays(diffInDays);
  }

  static AtticDate now(Position position) {
    return AtticDate.fromDateTime(DateTime.now(), position);
  }
}

const athens = Position(
  longitude: 23.727806,
  latitude: 37.983972,
  accuracy: 0.0,
  altitude: 0.0,
  heading: 0.0,
  speed: 0.0,
  speedAccuracy: 0.0,
  timestamp: null,
);
