import 'package:calunedar/redux/src/month_info.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';

import 'week.dart';

String _defaultSubText(DateTime dt, [DateInfo? event]) => '';

class Month extends StatelessWidget {
  const Month({
    Key? key,
    required this.firstWeek,
    required this.monthInfo,
    required this.isCurrentMonth,
    required this.getTextForDay,
    this.getSubTextForDay = _defaultSubText,
  }) : super(key: key);

  final DateTime firstWeek;
  final MonthInfo monthInfo;
  final bool Function(DateTime) isCurrentMonth;
  final String Function(DateTime) getTextForDay;
  final String Function(DateTime, [DateInfo? event]) getSubTextForDay;

  List<DateTime> _eachWeekOfMonth() {
    return List.generate(
      6,
      (index) => firstWeek.addDays(index * 7, true).startOfDay,
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
                getSubTextForDay: getSubTextForDay,
              ))
          .toList(),
    );
  }
}
