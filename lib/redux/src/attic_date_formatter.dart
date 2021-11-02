import 'package:calunedar/calendar/attic_date.dart';
import 'package:dart_date/dart_date.dart';
import 'package:intl/intl.dart';

import './month_info.dart';
import '../date_formatter.dart';

class AtticDateFormatter extends DateFormatter {
  final bool _useGreekName;
  final DateFormat _dateFormatter;

  AtticDateFormatter(this._useGreekName, bool use24hr)
      : _dateFormatter = use24hr ? DateFormat.Hm() : DateFormat.jm();

  @override
  String? dateSubText(DateTime date) {
    final atticDate = AtticDate.fromDateTime(date);

    return "${atticDate.monthName(_useGreekName)} ${atticDate.day}, ${atticDate.year}";
  }

  @override
  String dateText(DateTime date) {
    return AtticDate.fromDateTime(date).day.toString();
  }

  @override
  String formatForReadout(DateTime date) {
    final atticDate = AtticDate.fromDateTime(date);
    return '${atticDate.monthName(_useGreekName)} ${atticDate.day} at ${_dateFormatter.format(date)} ${DateFormatter.timeZoneAbbr(date)}';
  }

  @override
  String formatForHeader(DateTime date) {
    final atticDate = AtticDate.fromDateTime(date);
    return '${atticDate.monthName(_useGreekName)} ${atticDate.year}';
  }

  @override
  EventPinDates generatePinDates(DateTime date) {
    final atticDate = AtticDate.fromDateTime(date);
    final firstDay = date.addDays(-(atticDate.day - 1)).startOfDay;
    final lastDay = firstDay.addDays(atticDate.monthLength).startOfDay;
    return EventPinDates(start: firstDay, end: lastDay);
  }

  @override
  bool isSameMonth(DateTime testDate, DateTime otherDate) {
    return AtticDate.fromDateTime(testDate).month ==
        AtticDate.fromDateTime(otherDate).month;
  }

  @override
  DateTime getFirstDayForDisplay(DateTime date) {
    final atticDate = AtticDate.fromDateTime(date);
    final firstDay = date.addDays(-(atticDate.day - 1));
    return firstDay.isSunday ? firstDay : firstDay.startOfWeek;
  }
}
