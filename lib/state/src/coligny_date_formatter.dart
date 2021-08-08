import 'package:calunedar/calendar/coligny_date.dart';
import 'package:calunedar/widgets/calendar/src/month_info.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../date_formatter.dart';

class ColignyDateFormatter extends DateFormatter {
  final bool _metonic;
  final DateFormat _dateFormatter;

  ColignyDateFormatter(BuildContext context, this._metonic)
      : _dateFormatter = MediaQuery.of(context).alwaysUse24HourFormat
            ? DateFormat.Hm()
            : DateFormat.jm();

  @override
  String? dateSubText(DateTime date) {
    final colignyDate = ColignyDate.fromDateTime(date, _metonic);
    final inscriptions = colignyDate.inscription.join(" | ").trim();

    return "${colignyDate.monthName} ${colignyDate.day}, ${colignyDate.year}: $inscriptions";
  }

  @override
  String dateText(DateTime date) {
    return ColignyDate.fromDateTime(date, _metonic).day.toString();
  }

  @override
  String formatForReadout(DateTime date) {
    final colignyDate = ColignyDate.fromDateTime(date, _metonic);
    return '${colignyDate.monthName} ${colignyDate.day} at ${_dateFormatter.format(date)}';
  }

  @override
  String formatForHeader(DateTime date) {
    final colignyDate = ColignyDate.fromDateTime(date, _metonic);
    return '${colignyDate.monthName} ${colignyDate.year}';
  }

  @override
  EventPinDates generatePinDates(DateTime date) {
    final colignyDate = ColignyDate.fromDateTime(date, _metonic);
    final firstDay = date.addDays(-(colignyDate.day - 1)).startOfDay;
    final lastDay = firstDay.addDays(colignyDate.monthLength).startOfDay;
    return EventPinDates(start: firstDay, end: lastDay);
  }

  @override
  bool isSameMonth(DateTime testDate, DateTime otherDate) {
    return ColignyDate.fromDateTime(testDate, _metonic).month ==
        ColignyDate.fromDateTime(otherDate, _metonic).month;
  }

  @override
  DateTime getFirstDayForDisplay(DateTime date) {
    final colignyDate = ColignyDate.fromDateTime(date, _metonic);
    final firstDay = date.addDays(-(colignyDate.day - 1));
    return firstDay.isSunday ? firstDay : firstDay.startOfWeek;
  }
}
