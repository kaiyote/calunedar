import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:flutter/material.dart';

import 'month_info.dart';
import 'week.dart';

class Month extends StatelessWidget {
  Month({@required this.date, @required this.monthInfo});

  final ColignyCalendar date;
  final MonthInfo monthInfo;

  List<ColignyCalendar> _eachWeekOfMonth() {
    var firstDay = ColignyCalendar(date.year, date.month, 1, date.metonic);

    var firstWeek = firstDay.weekday == 7 // sunday
        ? firstDay
        : firstDay.addDays(-firstDay.weekday);

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
          .map((weekStart) =>
              Week(start: weekStart, month: date.month, monthInfo: monthInfo))
          .toList(),
    );
  }
}
