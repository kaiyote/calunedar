import 'package:dart_date/dart_date.dart';

class ColignyMonth {
  int index;
  String omen;
  final String name;
  int days;

  ColignyMonth(this.name, this.days) {
    this.index = 0;
    this.omen = this.days == 30 ? "MAT" : "ANM";
  }

  @override
  toString() {
    return """
days: ${this.days}
  index: ${this.index}
  name: ${this.name}
  omen: ${this.omen}""";
  }
}

class ColignyYear {
  final int year;
  final bool metonic;
  List<ColignyMonth> months;
  int ident;
  int yearDays;

  ColignyYear(this.year, [this.metonic = false]) {
    this.months = [
      ColignyMonth("Samonios", 30),
      ColignyMonth("Dumanios", 29),
      ColignyMonth("Riuros", 30),
      ColignyMonth("Anagantios", 29),
      ColignyMonth("Ogronios", 30),
      ColignyMonth("Cutios", 30),
      ColignyMonth("Giamonios", 29),
      ColignyMonth("Simiuisonna", 30),
      ColignyMonth("Elembi", 29),
      ColignyMonth("Aedrinni", 30),
      ColignyMonth("Cantlos", 29)
    ];

    if (this.metonic) {
      this.ident = ColignyYear.metMap[(this.year - 4999) % 19];
    } else {
      this.ident = ColignyYear.satMap[(this.year - 4998) % 5];
    }

    switch (this.ident) {
      case 1:
        this.months.insert(0, ColignyMonth("Quimonios", 29));
        this.months.insert(8, ColignyMonth("Equos", 30));
        break;
      case 3:
        this.months.insert(8, ColignyMonth("Equos", 29));
        if (this.year - 4998 % 30 != 27 || this.metonic) {
          this.months.insert(6, ColignyMonth("Rantaranos", 30));
        }
        break;
      case 5:
        this.months.insert(8, ColignyMonth("Equos", 30));
        break;
      default:
        this.months.insert(8, ColignyMonth("Equos", 29));
        break;
    }

    if (this.metonic) {
      if ((this.year - 4999).abs() >= 60.97 &&
          (this.year - 4999).abs() % 60.97 <= 5 &&
          this.ident == 5) {
        this.months[8].days = 29;
      }

      if ((this.year - 4999).abs() > 6568.62 &&
          (this.year - 4999).abs() % 60.97 <= 5 &&
          this.ident == 3) {
        this.months.removeAt(6);
      }
    } else {
      if ((this.year - 4998).abs() >= 197.97 &&
          (this.year - 4998).abs() % 197.97 <= 5 &&
          this.ident == 5) {
        this.months[8].days = 29;
      }

      if ((this.year - 4998).abs() > 635.04 &&
          (this.year - 4998).abs() % 635.04 <= 30 &&
          this.year - 4998 % 30 == 27) {
        this.months.insert(6, ColignyMonth("Rantaranos", 30));
      }
    }

    this.yearDays = 0;

    for (var i = 0; i < this.months.length; i++) {
      this.months[i].index = i;
      this.yearDays += this.months[i].days;
    }
  }

  @override
  toString() {
    return """
ident: ${this.ident}
  metonic: ${this.metonic}
  year: ${this.year}
  yearDays: ${this.yearDays}
  #ofMonths: ${this.months.length}
  months: ${this.months.map((e) => e.name + '\n')}
    """;
  }

  static var metMap = {
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

  static var satMap = {
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

class ColignyDate {
  int year;
  ColignyMonth month;
  int day;
  final bool metonic;
  ColignyYear fullYear;
  int yearToBegin;
  int yearToEnd;

  ColignyDate(this.year, int month, this.day, [this.metonic = false]) {
    this.fullYear = ColignyYear(this.year, this.metonic);
    this.month = this.fullYear.months[month];

    this.yearToBegin = 0;

    for (var i = 0; i <= this.month.index; i++) {
      if (i == this.month.index) {
        this.yearToBegin += this.day;
      } else {
        this.yearToBegin += this.fullYear.months[i].days;
      }
    }

    this.yearToEnd = this.fullYear.yearDays - this.yearToBegin;
  }

  @override
  toString() {
    return """
day: ${this.day}
metonic: ${this.metonic}
year: ${this.year}
yearToBeing: ${this.yearToBegin}
yearToEnd: ${this.yearToEnd}
month: {
  ${this.month.toString()}
}
fullYear: {
  ${this.fullYear.toString()}
}
    """;
  }

  ColignyDate calcDays(int add) {
    var output =
        ColignyDate(this.year, this.month.index, this.day, this.metonic);
    output.day += add;

    while (output.day > output.month.days) {
      if (output.month.index == output.fullYear.months.length - 1) {
        output = ColignyDate(
            output.year + 1, 0, output.day - output.month.days, output.metonic);
      } else {
        output = ColignyDate(output.year, output.month.index + 1,
            output.day - output.month.days, output.metonic);
      }
    }

    while (output.day < 1) {
      if (output.month.index == 0) {
        var newLength =
            ColignyYear(output.year - 1, output.metonic).months.length;
        output = ColignyDate(output.year - 1, newLength - 1,
            output.day + output.month.days, output.metonic);
      } else {
        output = ColignyDate(output.year, output.month.index - 1,
            output.day + output.month.days, output.metonic);
      }
    }

    return output;
  }
}

extension Coligny on DateTime {
  ColignyDate toColignyDate(bool metonic) {
    double diff;
    ColignyDate output;
    var out = DateTime.fromMillisecondsSinceEpoch(this.millisecondsSinceEpoch);
    var tomorrow = out.hour >= 18;

    out = out.setHour(0, 0, 0, 0);

    if (metonic) {
      diff = out.diff(DateTime(1999, 5, 22)).inMilliseconds / 8.64e7;
      output = ColignyDate(4999, 0, 1, true);
    } else {
      diff = out.diff(DateTime(1998, 5, 3)).inMilliseconds / 8.64e7;
      output = ColignyDate(4998, 0, 1);
    }

    if (tomorrow) {
      return output.calcDays(diff.round());
    } else {
      return output.calcDays((diff - 1).round());
    }
  }
}
