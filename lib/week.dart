import 'package:coligny_calendar/day.dart';
import 'package:coligny_calendar/month.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

class Week extends StatelessWidget {
  Week({@required this.start, @required this.month, @required this.events});

  final int month;
  final DateTime start;
  final Set<MoonInfo> events;

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
      children: dates.map((DateTime date) {
        return Day(
          date: date,
          isCurrentMonth: date.month == month,
          event: events.firstWhere(
            (element) => element.when.isSameDay(date),
            orElse: () => MoonInfo(phase: Phase.INVALID, when: Date.today),
          ),
        );
      }).toList(),
    );
  }
}
