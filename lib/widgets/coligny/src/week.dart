import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:flutter/material.dart';

import 'day.dart';
import 'month_info.dart';

class Week extends StatelessWidget {
  Week({@required this.start, @required this.month, @required this.monthInfo});

  final int month;
  final ColignyCalendar start;
  final MonthInfo monthInfo;

  @override
  Widget build(BuildContext context) {
    var dates = List.generate(
      7,
      (index) => start.addDays(index),
      growable: false,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: dates
          .map(
            (date) => Day(
              date: date,
              isCurrentMonth: date.month == month,
              event: monthInfo.lunarEvents.firstWhere(
                (element) => element.when.day == date.day,
                orElse: () => DateInfo(
                  phase: Event.none,
                  when: date.toDateTime(),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
