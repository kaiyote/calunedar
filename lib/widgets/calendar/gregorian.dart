import 'package:calunedar/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dart_date/dart_date.dart';
import 'package:intl/intl.dart';

import 'src/month.dart';
import 'src/month_info.dart';
import 'src/readout.dart';

class GregorianDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final buildDate = context.select<AppState, DateTime>((state) => state.date);
    var dateFormatter = DateFormat.MMMMd().addPattern('\'at\'');
    dateFormatter = MediaQuery.of(context).alwaysUse24HourFormat
        ? dateFormatter.add_Hm()
        : dateFormatter.add_jm();

    final monthInfo = MonthInfo(
      date: buildDate,
      isSameMonth: (date, other) => date.isSameMonth(other),
      generatePinDates: (date) => EventPinDates(
        start: date.startOfMonth,
        end: date.endOfMonth.startOfDay,
      ),
    );

    var firstWeek = buildDate.startOfMonth.isSunday
        ? buildDate.startOfMonth
        : buildDate.startOfMonth.startOfWeek;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Month(
          monthInfo: monthInfo,
          firstWeek: firstWeek,
          isCurrentMonth: (testDate) => testDate.month == buildDate.month,
          getTextForDay: (testDate) => testDate.day.toString(),
        ),
        Divider(color: Colors.black, thickness: 1.0, height: 30.0),
        Readout(monthInfo: monthInfo, formatDate: dateFormatter.format),
      ],
    );
  }
}
