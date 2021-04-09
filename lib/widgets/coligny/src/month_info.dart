import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:calunedar/widgets/gregorian/src/month_info.dart' hide MonthInfo;
import 'package:dart_date/dart_date.dart';
import 'package:meeus/julian.dart';
import 'package:meeus/meeus.dart';

class MonthInfo {
  MonthInfo({this.date, this.metonic});

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
    var colignyDate = ColignyCalendar.fromDateTime(date, metonic);
    var firstDay = date.addDays(-(colignyDate.day - 1)).startOfDay;
    var lastDay = date.addDays(colignyDate.monthLength).startOfDay;
    var midpoint = firstDay.addDays(lastDay.differenceInDays(firstDay) ~/ 2);

    var dates = Set<DateInfo>();
    for (var date in [firstDay, lastDay, midpoint]) {
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
            ColignyCalendar.fromDateTime(date, metonic).month)
        .toSet();
  }
}
