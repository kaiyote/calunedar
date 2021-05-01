import 'package:calunedar/app_state.dart';
import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dart_date/dart_date.dart';
import 'package:intl/intl.dart';

import 'src/month.dart';
import 'src/month_info.dart';
import 'src/readout.dart';

class ColignyDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final buildDate = context.select<AppState, DateTime>((state) => state.date);
    final metonic = context.select<AppState, bool>((state) => state.metonic);
    final colignyDate = ColignyCalendar.fromDateTime(buildDate, metonic);
    final dateFormatter = MediaQuery.of(context).alwaysUse24HourFormat
        ? DateFormat.Hm()
        : DateFormat.jm();

    final monthInfo = MonthInfo(
      date: buildDate,
      generatePinDates: (date) {
        var firstDay = date.addDays(-(colignyDate.day - 1)).startOfDay;
        var lastDay = firstDay.addDays(colignyDate.monthLength).startOfDay;
        return EventPinDates(start: firstDay, end: lastDay);
      },
      isSameMonth: (date, other) =>
          ColignyCalendar.fromDateTime(date, metonic).month ==
          ColignyCalendar.fromDateTime(other, metonic).month,
    );

    var firstDay = buildDate.addDays(-(colignyDate.day - 1));
    var firstWeek = firstDay.isSunday ? firstDay : firstDay.startOfWeek;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Month(
          monthInfo: monthInfo,
          firstWeek: firstWeek,
          getTextForDay: (testDate) =>
              ColignyCalendar.fromDateTime(testDate, metonic).day.toString(),
          isCurrentMonth: (testDate) =>
              ColignyCalendar.fromDateTime(testDate, metonic).month ==
              colignyDate.month,
        ),
        Divider(color: Colors.black, thickness: 1.0, height: 30.0),
        Readout(
            monthInfo: monthInfo,
            formatDate: (dt) {
              var colignyDate = ColignyCalendar.fromDateTime(dt, metonic);
              return '${colignyDate.monthName} ${colignyDate.day} at ${dateFormatter.format(dt.toLocal())}';
            }),
      ],
    );
  }
}
