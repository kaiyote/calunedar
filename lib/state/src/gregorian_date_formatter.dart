import 'package:calunedar/state/date_formatter.dart';
import 'package:calunedar/widgets/calendar/src/month_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dart_date/dart_date.dart';

class GregorianDateFormatter extends DateFormatter {
  final DateFormat _dateFormatter;

  GregorianDateFormatter(BuildContext context)
      : _dateFormatter = MediaQuery.of(context).alwaysUse24HourFormat
            ? DateFormat.MMMMd().addPattern("'at'").add_Hm()
            : DateFormat.MMMMd().addPattern("'at;").add_jm();

  @override
  String? dateSubText(DateTime date) {
    return null;
  }

  @override
  String dateText(DateTime date) {
    return date.day.toString();
  }

  @override
  String formatForReadout(DateTime date) {
    return _dateFormatter.format(date);
  }

  @override
  String formatForHeader(DateTime date) {
    return '${DateFormat.MMMM().format(date)} ${date.year}';
  }

  @override
  EventPinDates generatePinDates(DateTime date) {
    return EventPinDates(
      start: date.startOfMonth,
      end: date.endOfMonth.startOfDay,
    );
  }

  @override
  bool isSameMonth(DateTime testDate, DateTime otherDate) {
    return testDate.isSameMonth(otherDate);
  }

  @override
  DateTime getFirstDayForDisplay(DateTime date) {
    return date.startOfMonth.isSunday
        ? date.startOfMonth
        : date.startOfMonth.startOfWeek;
  }
}
