import 'package:calunedar/calendar/coligny_date.dart';
import 'package:dart_date/dart_date.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intl/intl.dart';

import './month_info.dart';
import '../date_formatter.dart';

class ColignyDateFormatter extends DateFormatter {
  final bool _metonic;
  final DateFormat _dateFormatter;

  ColignyDateFormatter(this._metonic, bool use24hr)
      : _dateFormatter = use24hr ? DateFormat.Hm() : DateFormat.jm();

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
    return '${colignyDate.monthName} ${colignyDate.day} at ${_dateFormatter.format(date)} ${DateFormatter.timeZoneAbbr(date)}';
  }

  @override
  String formatForHeader(DateTime date) {
    final colignyDate = ColignyDate.fromDateTime(date, _metonic);
    return '${colignyDate.monthName} ${colignyDate.year}';
  }

  @override
  EventPinDates generatePinDates(DateTime date) {
    final colignyDate = ColignyDate.fromDateTime(date, _metonic);
    final firstDay = date.addDays(-(colignyDate.day - 1), true).startOfDay;
    final lastDay = firstDay.addDays(colignyDate.monthLength, true).startOfDay;
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
    final firstDay = date.addDays(-(colignyDate.day - 1), true);
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

    final monthName = ColignyDate.fromDateTime(event.when, _metonic).monthName;
    final eventType =
        [Event.decemberSolstice, Event.juneSolstice].contains(event.phase)
            ? 'solstice'
            : 'equinox';

    return '$monthName $eventType';
  }

  @override
  String subTextForDay(DateTime date, [DateInfo? event]) {
    String eventSubText = '';

    if (event != null && event.phase != Event.none) {
      eventSubText =
          '${formatEvent(event)} at ${_dateFormatter.format(event.when)} ${DateFormatter.timeZoneAbbr(event.when)}';
    }

    return '${dateSubText(date)}\n$eventSubText'.trim();
  }
}
