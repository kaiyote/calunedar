import 'package:calunedar/state/app_state.dart';
import 'package:calunedar/state/date_formatter.dart';
import 'package:calunedar/state/settings.dart';
import 'package:calunedar/widgets/calendar/src/month.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final dateFormatter = context
        .select<Settings, DateFormatter>((s) => s.dateFormatter(context));
    final calendar = context.select<Settings, CalendarType>((s) => s.calendar);

    return Month(
      monthInfo: state.monthInfo(context),
      firstWeek: dateFormatter.getFirstDayForDisplay(state.date),
      getTextForDay: dateFormatter.dateText,
      isCurrentMonth: (testDate) =>
          dateFormatter.isSameMonth(state.date, testDate),
      getSubTextForDay: (date, [event]) =>
          '${dateFormatter.dateSubText(date) ?? ''}\n${event?.toString(date: calendar == CalendarType.GREGORIAN)}',
    );
  }
}
