import 'package:calunedar/widgets/month_info.dart';
import 'package:calunedar/widgets/week.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

class Month extends StatelessWidget {
  Month({@required this.date, @required this.monthInfo});

  final DateTime date;
  final MonthInfo monthInfo;

  List<DateTime> _eachWeekOfMonth() {
    var firstWeek = date.startOfMonth.isSunday
        ? date.startOfMonth
        : date.startOfMonth.startOfWeek;

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
