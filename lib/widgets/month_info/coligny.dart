import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:calunedar/widgets/month_info/month_info.dart';
import 'package:dart_date/dart_date.dart';
import 'package:meeus/julian.dart';
import 'package:meeus/meeus.dart';

class ColignyMonthInfo implements MonthInfo {
  ColignyMonthInfo({this.date, this.metonic}) {
    colignyDate = ColignyCalendar.fromDateTime(this.date, metonic);
  }

  ColignyCalendar colignyDate;
  final DateTime date;
  final bool metonic;
  Set<DateInfo> _lunarEvents = Set();

  Set<DateInfo> get lunarEvents {
    if (_lunarEvents.isEmpty) {
      _lunarEvents = _generateLunarEvents();
    }

    return _lunarEvents;
  }

  Set<DateInfo> _generateLunarEvents() {
    var firstDay =
        ColignyCalendar(colignyDate.year, colignyDate.month, 1, metonic);
    var lastDay = ColignyCalendar(colignyDate.year, colignyDate.month, 1)
        .addMonths(1)
        .addDays(-1)
        .toDateTime();
    var midpoint = firstDay
        .addDays(15)
        .toDateTime(); // months are all 29 or 30, 15 is close enough

    var dates = Set<DateInfo>();
    for (var date in [firstDay.toDateTime(), lastDay, midpoint]) {
      var daysBetween = date.differenceInDays(date.startOfYear);
      var yearFraction = date.year + (daysBetween / 356.25);

      dates.add(DateInfo(
        phase: Event.firstQuarter,
        when: jdToDateTime(first(yearFraction)).local,
      ));
      dates.add(DateInfo(
        phase: Event.fullMoon,
        when: jdToDateTime(full(yearFraction)).local,
      ));
      dates.add(DateInfo(
        phase: Event.thirdQuarter,
        when: jdToDateTime(last(yearFraction)).local,
      ));
      dates.add(DateInfo(
        phase: Event.newMoon,
        when: jdToDateTime(newMoon(yearFraction)).local,
      ));
    }

    return dates
        .where((element) =>
            ColignyCalendar.fromDateTime(element.when, metonic).month ==
            colignyDate.month)
        .toSet();
  }
}
