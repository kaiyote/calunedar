import 'package:calunedar/app_state.dart';
import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:calunedar/widgets/calendar/src/month_info.dart';
import 'package:dart_date/dart_date.dart';

MonthInfo buildMonthInfo(AppState state) {
  return MonthInfo(
    date: state.date,
    generatePinDates: _generatePinDateFunc(state),
    isSameMonth: _generateIsSameMonth(state),
  );
}

bool Function(DateTime, DateTime) _generateIsSameMonth(AppState state) {
  switch (state.calendar) {
    case CalendarType.COLIGNY:
      return (date, other) =>
          ColignyCalendar.fromDateTime(date, state.metonic).month ==
          ColignyCalendar.fromDateTime(other, state.metonic).month;
    default:
      return (date, other) => date.isSameMonth(other);
  }
}

EventPinDates Function(DateTime) _generatePinDateFunc(AppState state) {
  switch (state.calendar) {
    case CalendarType.COLIGNY:
      return _colignyPinDates(state);
    default:
      return _gregorianPinDates();
  }
}

EventPinDates Function(DateTime) _gregorianPinDates() {
  return (date) => EventPinDates(
        start: date.startOfMonth,
        end: date.endOfMonth.startOfDay,
      );
}

EventPinDates Function(DateTime) _colignyPinDates(AppState state) {
  var colignyDate = ColignyCalendar.fromDateTime(state.date, state.metonic);

  return (date) {
    var firstDay = date.addDays(-(colignyDate.day - 1)).startOfDay;
    var lastDay = firstDay.addDays(colignyDate.monthLength).startOfDay;
    return EventPinDates(
      start: firstDay,
      end: lastDay,
    );
  };
}
