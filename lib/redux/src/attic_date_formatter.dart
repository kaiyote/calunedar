import 'package:calunedar/calendar/attic_date.dart';
import 'package:dart_date/dart_date.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import './month_info.dart';
import '../date_formatter.dart';

class AtticDateFormatter extends DateFormatter {
  final bool _useGreekName;
  final DateFormat _dateFormatter;
  final Position _position;

  AtticDateFormatter(this._useGreekName, this._position, bool use24hr)
      : _dateFormatter = use24hr ? DateFormat.Hm() : DateFormat.jm();

  @override
  String? dateSubText(DateTime date) {
    final atticDate = AtticDate.fromDateTime(date, _position);

    return "${_useGreekName ? atticDate.greekMonthName : atticDate.monthName} ${atticDate.day}, ${atticDate.year}/${atticDate.year + 1}";
  }

  @override
  String dateText(DateTime date) {
    return AtticDate.fromDateTime(date, _position).day.toString();
  }

  @override
  String formatForReadout(DateTime date) {
    final atticDate = AtticDate.fromDateTime(date, _position);
    return '${_useGreekName ? atticDate.greekMonthName : atticDate.monthName} ${atticDate.day} at ${_dateFormatter.format(date)} ${DateFormatter.timeZoneAbbr(date)}';
  }

  @override
  String formatForHeader(DateTime date) {
    final atticDate = AtticDate.fromDateTime(date, _position);
    return '${_useGreekName ? atticDate.greekMonthName : atticDate.monthName} ${atticDate.year}/${atticDate.year + 1}';
  }

  @override
  EventPinDates generatePinDates(DateTime date) {
    final atticDate = AtticDate.fromDateTime(date, _position);
    final firstDay = date.addDays(-(atticDate.day - 1), true).startOfDay;
    final lastDay = firstDay.addDays(atticDate.monthLength, true).startOfDay;
    return EventPinDates(start: firstDay, end: lastDay);
  }

  @override
  bool isSameMonth(DateTime testDate, DateTime otherDate) {
    return AtticDate.fromDateTime(testDate, _position).month ==
        AtticDate.fromDateTime(otherDate, _position).month;
  }

  @override
  DateTime getFirstDayForDisplay(DateTime date) {
    final atticDate = AtticDate.fromDateTime(date, _position);
    final firstDay = date.addDays(-(atticDate.day - 1), true);
    return firstDay.isSunday
        ? firstDay.startOfDay
        : firstDay.startOfWeek.startOfDay;
  }

  @override
  String formatEvent(DateInfo event) {
    if (event.phase == Event.none) return '';

    if ([Event.firstQuarter, Event.fullMoon, Event.thirdQuarter, Event.newMoon]
        .contains(event.phase)) {
      return EnumToString.convertToString(event.phase, camelCase: true);
    }

    final month = AtticDate.fromDateTime(event.when, _position);
    final monthName = _useGreekName ? month.greekMonthName : month.monthName;
    final eventType =
        [Event.decemberSolstice, Event.juneSolstice].contains(event.phase)
            ? 'solstice'
            : 'equinox';

    return '$monthName $eventType';
  }

  @override
  String subTextForDay(DateTime date, [DateInfo? event]) {
    String eventSubText = '';

    if (event != null) {
      eventSubText =
          '${formatEvent(event)} at ${_dateFormatter.format(event.when)} ${DateFormatter.timeZoneAbbr(event.when)}';
    }

    return '${dateSubText(date)}\n$eventSubText'.trim();
  }
}
