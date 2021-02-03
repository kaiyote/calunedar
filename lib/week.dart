import 'package:coligny_calendar/day.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

class Week extends StatelessWidget {
  Week({@required this.start, @required this.month});

  final int month;
  final DateTime start;

  @override
  Widget build(BuildContext context) {
    var dates =
        List.generate(7, (index) => start.addDays(index), growable: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: dates.map((DateTime date) {
        return Day(
          date: date,
          isCurrentMonth: date.month == month,
        );
      }).toList(),
    );
  }
}
