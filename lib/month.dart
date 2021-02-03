import 'package:coligny_calendar/week.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

class Month extends StatelessWidget {
  Month({@required this.date});

  final DateTime date;

  List<DateTime> _eachWeekOfMonth() {
    var firstWeek = date.startOfMonth.startOfWeek;
    var endOfMonth = date.endOfMonth;

    var list = List<DateTime>();
    list.add(firstWeek);

    while (list.last.addDays(7) < endOfMonth) {
      list.add(list.last.addDays(7));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _eachWeekOfMonth().map((DateTime weekStart) {
          return Week(start: weekStart, month: date.month);
        }).toList(),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    );
  }
}
