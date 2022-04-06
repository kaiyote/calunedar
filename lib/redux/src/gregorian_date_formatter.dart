import 'package:dart_date/dart_date.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intl/intl.dart';

import './month_info.dart';
import '../date_formatter.dart';

class GregorianDateFormatter extends DateFormatter {
  final DateFormat _dateFormatter;
  final DateFormat _timeFormatter;

  GregorianDateFormatter(bool use24hr)
      : _dateFormatter = use24hr
            ? DateFormat.MMMMd().addPattern("'at'").add_Hm()
            : DateFormat.MMMMd().addPattern("'at'").add_jm(),
        _timeFormatter = use24hr ? DateFormat.Hm() : DateFormat.jm();

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
    return "${_dateFormatter.format(date)} ${DateFormatter.timeZoneAbbr(date)}";
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
        ? date.startOfMonth.startOfDay
        : date.startOfMonth.startOfWeek.startOfDay;
  }

  @override
  String formatEvent(DateInfo event) {
    return EnumToString.convertToString(event.phase, camelCase: true);
  }

  @override
  String subTextForDay(DateTime date, [DateInfo? event]) {
    String eventSubText = '';

    if (event != null) {
      eventSubText =
          '${formatEvent(event)} at ${_timeFormatter.format(event.when)} ${DateFormatter.timeZoneAbbr(event.when)}';
    }

    return eventSubText.trim();
  }
}
