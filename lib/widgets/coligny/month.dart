import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:calunedar/widgets/month_info/month_info.dart';
import './week.dart';
import 'package:flutter/material.dart';

class ColignyMonth extends StatelessWidget {
  ColignyMonth({@required this.date, @required this.monthInfo});

  final ColignyCalendar date;
  final MonthInfo monthInfo;

  List<ColignyCalendar> _eachWeekOfMonth() {
    var firstDayOfMonth =
        ColignyCalendar(date.year, date.month, 1, date.metonic);

    var firstWeek = firstDayOfMonth.weekday == 7
        ? firstDayOfMonth
        : firstDayOfMonth.addDays(-(firstDayOfMonth.weekday + 1));

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
