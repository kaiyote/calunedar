import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';

import 'month_info.dart';
import 'week.dart';

class Month extends StatelessWidget {
  Month({
    @required this.firstWeek,
    @required this.monthInfo,
    @required this.isCurrentMonth,
    @required this.getTextForDay,
  });

  final DateTime firstWeek;
  final MonthInfo monthInfo;
  final bool Function(DateTime) isCurrentMonth;
  final String Function(DateTime) getTextForDay;

  List<DateTime> _eachWeekOfMonth() {
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
                isCurrentMonth: isCurrentMonth,
                monthInfo: monthInfo,
                getTextForDay: getTextForDay,
              ))
          .toList(),
    );
  }
}
