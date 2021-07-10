import 'package:dart_date/dart_date.dart';
import './coligny_calendar_inscriptions.dart';

class ColignyMonth {
  final String _name;
  int days;
  int index;

  ColignyMonth(this._name, this.days) {
    if (days != 30 && days != 29)
      throw RangeError('Months only have 29 or 30 days');

    index = 0;
  }

  String get name => _name;
  String get omen => days == 30 ? 'MAT' : 'ANM';
}

class ColignyYear {
  final int _year;
  final bool _metonic;
  List<ColignyMonth> _months;
  int _ident;
  int _yearDays;

  ColignyYear(this._year, [this._metonic = false]) {
    _months = <ColignyMonth>[
      ColignyMonth('Samonios', 30),
      ColignyMonth('Dumanios', 29),
      ColignyMonth('Riuros', 30),
      ColignyMonth('Anagantios', 29),
      ColignyMonth('Ogronios', 30),
      ColignyMonth('Cutios', 30),
      ColignyMonth('Giamonios', 29),
      ColignyMonth('Simiuisonna', 30),
      ColignyMonth('Elembi', 29),
      ColignyMonth('Aedrinni', 30),
      ColignyMonth('Cantlos', 29),
    ];

    _ident = _metonic
        ? _metonicMap[(_year - 4999) % 19]
        : _saturnMap[(_year - 4998) % 5];

    final saturnCycleYear = (_year - 4998) % 30;

    switch (_ident) {
      case 1:
        _months.insert(0, ColignyMonth('Quimonios', 29));
        _months.insert(8, ColignyMonth('Equos', 30));
        break;
      case 3:
        _months.insert(8, ColignyMonth('Equos', 29));
        if (_metonic || (saturnCycleYear != 27 && saturnCycleYear != -3)) {
          _months.insert(6, ColignyMonth('Rantaranos', 30));
        }
        break;
      case 5:
        _months.insert(8, ColignyMonth('Equos', 30));
        break;
      default:
        _months.insert(8, ColignyMonth('Equos', 29));
        break;
    }

    if (_metonic) {
      final absYear = (_year - 4999).abs();
      if (absYear >= 60.97 && absYear % 60.97 <= 5 && _ident == 5) {
        _months[8].days = 29;
      }

      if (absYear > 6568.62 && absYear % 6568.62 <= 5 && _ident == 3) {
        _months.removeAt(6);
      }
    } else {
      final absYear = (_year - 4998).abs();
      if (absYear >= 197.97 && absYear % 197.97 <= 5 && _ident == 5) {
        _months[8].days = 29;
      }

      if (absYear > 635.04 &&
          absYear % 635.04 <= 30 &&
          (saturnCycleYear == 27 || saturnCycleYear == -3)) {
        _months.insert(6, ColignyMonth('Rantaranos', 30));
      }
    }

    _yearDays = 0;

    for (int i = 0; i < _months.length; i++) {
      _months[i].index = i;
      _yearDays += _months[i].days;
    }
  }

  int get year => _year;
  bool get metonic => _metonic;
  List<ColignyMonth> get months => _months;
  int get daysInYear => _yearDays;
  int get ident => _ident;

  static Map<int, int> _metonicMap = {
    -18: 3,
    -17: 4,
    -16: 5,
    -15: 1,
    -14: 2,
    -13: 3,
    -12: 4,
    -11: 5,
    -10: 1,
    -9: 2,
    -8: 3,
    -7: 4,
    -6: 5,
    -5: 1,
    -4: 2,
    -3: 3,
    -2: 4,
    -1: 5,
    0: 2,
    1: 3,
    2: 4,
    3: 5,
    4: 1,
    5: 2,
    6: 3,
    7: 4,
    8: 5,
    9: 1,
    10: 2,
    11: 3,
    12: 4,
    13: 5,
    14: 1,
    15: 2,
    16: 3,
    17: 4,
    18: 5
  };

  static Map<int, int> _saturnMap = {
    -4: 2,
    -3: 3,
    -2: 4,
    -1: 5,
    0: 1,
    1: 2,
    2: 3,
    3: 4,
    4: 5
  };
}

class ColignyCalendar {
  int _year;
  int _day;
  final bool _metonic;
  ColignyYear _fullYear;
  ColignyMonth _month;

  ColignyCalendar(
    this._year, [
    int month = 1,
    this._day = 1,
    this._metonic = false,
  ]) {
    if (year < 0) throw new RangeError('Year must be positive');

    _fullYear = ColignyYear(_year, _metonic);
    if (month < 0 || month > _fullYear.months.length)
      throw new RangeError("Invalid Month");
    else
      _month = _fullYear.months[month - 1];
  }

  ColignyCalendar addDays(int days) {
    var output = this.copy();
    output._day += days;

    while (output.day > output._month.days) {
      if (output._month.index == output._fullYear.months.length - 1) {
        output = ColignyCalendar(output.year + 1, 1,
            output.day - output._month.days, output._metonic);
      } else {
        output = ColignyCalendar(output.year, output.month + 1,
            output.day - output._month.days, output._metonic);
      }
    }

    while (output.day < 1) {
      if (output.month == 1) {
        var newMonthLength =
            ColignyYear(output.year - 1, output._metonic).months.length;
        output = new ColignyCalendar(output.year - 1, newMonthLength - 1,
            output.day + output._month.days, output._metonic);
      } else {
        output = new ColignyCalendar(output.year, output.month - 1,
            output.day + output._month.days, output._metonic);
      }
    }

    return output;
  }

  ColignyCalendar firstDayOfMonth() {
    return ColignyCalendar(year, month, 1, metonic);
  }

  ColignyCalendar lastDayOfMonth() {
    return ColignyCalendar(year, month, _month.days, metonic);
  }

  ColignyCalendar firstDayOfYear() {
    return ColignyCalendar(year, 1, 1, metonic);
  }

  ColignyCalendar lastDayOfYear() {
    return ColignyCalendar(
      year,
      _fullYear.months.length,
      _fullYear.months.last.days,
      metonic,
    );
  }

  int compareTo(ColignyCalendar other) {
    if (_metonic != other._metonic)
      throw new ArgumentError("other must be same cycle as this");

    if (this == other) return 0;
    if (year != other.year) return year < other.year ? -1 : 1;
    if (month != other.month) return month < other.month ? -1 : 1;
    if (day != other.day) return day < other.day ? -1 : 1;
    return 0;
  }

  ColignyCalendar copy() {
    return ColignyCalendar(year, month, day, metonic);
  }

  bool operator ==(Object other) {
    return other is ColignyCalendar &&
        year == other.year &&
        month == other.month &&
        day == other.day &&
        metonic == other.metonic;
  }

  int get hashCode {
    var result = 17;
    result = 37 * result + year.hashCode;
    result = 37 * result + month.hashCode;
    result = 37 * result + day.hashCode;
    result = 37 * result + metonic.hashCode;
    return result;
  }

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
      inscriptions[monthName][_fullYear.ident - 1][day - 1];

  int _differenceInDays(ColignyCalendar target) {
    if (this.metonic != target.metonic) {
      throw ArgumentError("Cannot diff between different cycles");
    } else if (year == target.year) {
      return (dayOfYear - target.dayOfYear).abs();
    } else if (target.compareTo(this) < 0) {
      return target._differenceInDays(this);
    } else {
      int count = this.yearLength - this.dayOfYear + target.dayOfYear;

      for (int i = year + 1; i < target.year; i++) {
        ColignyYear current = ColignyYear(i, metonic);
        count += current.daysInYear;
      }

      return count.abs();
    }
  }

  DateTime toDateTime() {
    DateTime gregorianStart;
    ColignyCalendar colignyStart;

    if (metonic) {
      gregorianStart = DateTime(1999, 5, 22);
      colignyStart = ColignyCalendar(4999, 1, 1, true);
    } else {
      gregorianStart = DateTime(1998, 5, 3);
      colignyStart = ColignyCalendar(4998, 1, 1);
    }

    var daysBetween = _differenceInDays(colignyStart);

    if (this.compareTo(colignyStart) < 0)
      return gregorianStart.addDays(-daysBetween, true);
    else
      return gregorianStart.addDays(daysBetween, true);
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

  static ColignyCalendar fromDateTime(DateTime dt, [bool metonic = false]) {
    ColignyCalendar output;
    // push it to "tomorrow" if its after 6pm (ver rough "sunset")
    int diffInDays = dt.getHours >= 18 ? 1 : 0;

    if (metonic) {
      diffInDays += dt.differenceInDays(DateTime(1999, 5, 22));
      output = ColignyCalendar(4999, 1, 1, true);
    } else {
      diffInDays += dt.differenceInDays(DateTime(1998, 5, 3));
      output = ColignyCalendar(4998, 1, 1);
    }

    return output.addDays(diffInDays);
  }

  static ColignyCalendar now([bool metonic = false]) {
    return ColignyCalendar.fromDateTime(DateTime.now(), metonic);
  }
}
