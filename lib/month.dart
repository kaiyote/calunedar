import 'package:coligny_calendar/week.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart' as DartDate;
import 'package:meeus/julian.dart';
import 'package:meeus/meeus.dart';

enum Phase { first, full, third, newMoon, INVALID }

class MoonInfo implements Comparable {
  Phase phase;
  DateTime when;

  MoonInfo({this.phase, this.when});

  String toString() => "{ ${this.phase.toString()}, $when }";

  bool operator ==(other) {
    if (other is! MoonInfo) return false;
    return this.phase == other.phase && this.when == other.when;
  }

  @override
  int get hashCode => this.phase.hashCode + this.when.hashCode;

  @override
  int compareTo(other) {
    return when.compareTo(other.when);
  }
}

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

  Set<MoonInfo> _lunarEventsInMonth(List<DateTime> sundays) {
    var firstDay = sundays.first;
    var lastDay = sundays.last;
    var midpoint = firstDay.addDays(lastDay.differenceInDays(firstDay) ~/ 2);

    var dates = Set<MoonInfo>();
    for (var date in [firstDay, lastDay, midpoint]) {
      var daysBetween = date.differenceInDays(date.startOfYear);
      var yearFraction = date.year + (daysBetween / 356.25);

      dates.add(MoonInfo(
        phase: Phase.first,
        when: jdToDateTime(
          first(yearFraction),
        ),
      ));
      dates.add(MoonInfo(
        phase: Phase.full,
        when: jdToDateTime(
          full(yearFraction),
        ),
      ));
      dates.add(MoonInfo(
        phase: Phase.third,
        when: jdToDateTime(
          last(yearFraction),
        ),
      ));
      dates.add(MoonInfo(
        phase: Phase.newMoon,
        when: jdToDateTime(
          newMoon(yearFraction),
        ),
      ));
    }
    return dates.where((element) => element.when.isSameMonth(date)).toSet();
  }

  @override
  Widget build(BuildContext context) {
    var weeks = _eachWeekOfMonth();
    var events = _lunarEventsInMonth(weeks);

    var children = _buildCalendar(weeks, events);
    children.addAll(_buildMonthInfo(events));

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: children,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    );
  }

  List<Widget> _buildCalendar(List<DateTime> weeks, Set<MoonInfo> events) {
    return weeks.map<Widget>((DateTime weekStart) {
      var eventsInWeek = events
          .where((element) => element.when.isWithinInterval(
              DartDate.Interval(weekStart, weekStart.addDays(7))))
          .toSet();

      return Week(
        start: weekStart,
        month: date.month,
        events: eventsInWeek,
      );
    }).toList();
  }

  List<Text> _buildMonthInfo(Set<MoonInfo> events) {
    var list = List<MoonInfo>.from(events);
    list.sort();

    return list
        .map<Text>((info) => Text(
              '${info.phase} at ${info.when.toLocal().format('MMM dd, yyyy hh:mm a')}',
            ))
        .toList();
  }
}
