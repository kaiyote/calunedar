import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';

import 'month_info.dart';
import 'week.dart';

class Month extends StatelessWidget {
  Month({
    @required this.date,
    @required this.monthInfo,
    @required this.metonic,
  });

  final DateTime date;
  final MonthInfo monthInfo;
  final bool metonic;

  List<DateTime> _eachWeekOfMonth() {
    var colignyDate = ColignyCalendar.fromDateTime(date, metonic);
    var firstDay = date.addDays(-(colignyDate.day - 1));
    var firstWeek = firstDay.isSunday ? firstDay : firstDay.startOfWeek;

    return List.generate(
      6,
      (index) => firstWeek.addWeeks(index),
      growable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _eachWeekOfMonth()
          .map((weekStart) => Week(
                start: weekStart,
                month: ColignyCalendar.fromDateTime(date, metonic).month,
                monthInfo: monthInfo,
                metonic: metonic,
              ))
          .toList(),
    );
  }
}
