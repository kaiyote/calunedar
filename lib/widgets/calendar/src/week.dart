import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';

import 'day.dart';
import 'month_info.dart';

class Week extends StatelessWidget {
  Week({
    required this.start,
    required this.isCurrentMonth,
    required this.monthInfo,
    required this.getTextForDay,
    required this.getSubTextForDay,
  });

  final bool Function(DateTime) isCurrentMonth;
  final String Function(DateTime) getTextForDay;
  final String Function(DateTime, [DateInfo? event]) getSubTextForDay;
  final DateTime start;
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
              isCurrentMonth: isCurrentMonth(date),
              event: monthInfo.lunarEvents.firstWhere(
                (element) => element.when.isSameDay(date),
                orElse: () => DateInfo(phase: Event.none, when: date),
              ),
              getTextForDay: getTextForDay,
              getSubTextForDay: getSubTextForDay,
            ),
          )
          .toList(),
    );
  }
}
