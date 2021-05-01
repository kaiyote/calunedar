import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';

import 'day.dart';
import 'month_info.dart';
import '../../gregorian/src/month_info.dart' hide MonthInfo;

class Week extends StatelessWidget {
  Week({
    @required this.start,
    @required this.month,
    @required this.monthInfo,
    @required this.metonic,
  });

  final int month;
  final DateTime start;
  final MonthInfo monthInfo;
  final bool metonic;

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
          .map((date) => Day(
              date: date,
              isCurrentMonth:
                  ColignyCalendar.fromDateTime(date, metonic).month == month,
              metonic: metonic,
              event: monthInfo.lunarEvents.firstWhere(
                (element) => element.when.isSameDay(date),
                orElse: () => DateInfo(phase: Event.none, when: date),
              )))
          .toList(),
    );
  }
}
