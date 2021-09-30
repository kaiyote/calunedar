import 'package:dart_date/dart_date.dart';
import 'package:intl/intl.dart';

import './month_info.dart';
import '../date_formatter.dart';

class GregorianDateFormatter extends DateFormatter {
  final DateFormat _dateFormatter;

  GregorianDateFormatter(bool use24hr)
      : _dateFormatter = use24hr
            ? DateFormat.MMMMd().addPattern("'at'").add_Hm()
            : DateFormat.MMMMd().addPattern("'at'").add_jm();

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
