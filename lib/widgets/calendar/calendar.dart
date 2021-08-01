import 'package:calunedar/app_state.dart';
import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:calunedar/widgets/calendar/src/month.dart';
import 'package:calunedar/widgets/calendar/src/month_info.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  Calendar({
    required this.state,
    required this.monthInfo,
  });

  final AppState state;
  final MonthInfo monthInfo;

  @override
  Widget build(BuildContext context) {
    switch (state.calendar) {
      case CalendarType.COLIGNY:
        return _coligny();
      default:
        return _gregorian();
    }
  }

  Widget _gregorian() {
    var firstWeek = state.date.startOfMonth.isSunday
        ? state.date.startOfMonth
        : state.date.startOfMonth.startOfWeek;

    return Month(
      monthInfo: monthInfo,
      firstWeek: firstWeek,
      isCurrentMonth: (testDate) => testDate.month == state.date.month,
      getTextForDay: (testDate) => testDate.day.toString(),
      getSubTextForDay: (testDate, [event]) => '',
    );
  }

  Widget _coligny() {
    final colignyDate = ColignyCalendar.fromDateTime(state.date, state.metonic);
    final firstDay = state.date.addDays(-(colignyDate.day - 1));
    final firstWeek = firstDay.isSunday ? firstDay : firstDay.startOfWeek;

    return Month(
      monthInfo: monthInfo,
      firstWeek: firstWeek,
      getTextForDay: (testDate) =>
          ColignyCalendar.fromDateTime(testDate, state.metonic).day.toString(),
      isCurrentMonth: (testDate) =>
          ColignyCalendar.fromDateTime(testDate, state.metonic).month ==
          colignyDate.month,
      getSubTextForDay: (testDate, [event]) {
        final date = ColignyCalendar.fromDateTime(testDate, state.metonic);
        final inscriptions = date.inscription.join(" | ").trim();

        return "${date.monthName} ${date.day}, ${date.year}: $inscriptions\n${event?.toString(date: false)}"
            .trim();
      },
    );
  }
}
