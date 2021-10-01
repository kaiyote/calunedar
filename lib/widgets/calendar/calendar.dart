import 'package:calunedar/redux/date_formatter.dart';
import 'package:calunedar/redux/models.dart';
import 'package:calunedar/redux/src/month_info.dart';
import 'package:calunedar/widgets/calendar/src/month.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class _ViewModel {
  const _ViewModel({
    required this.monthInfo,
    required this.date,
    required this.formatter,
    required this.calendarType,
    required this.use24hr,
  });

  final MonthInfo monthInfo;
  final DateTime date;
  final DateFormatter formatter;
  final CalendarType calendarType;
  final bool use24hr;
}

class Calendar extends StatelessWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      builder: (context, state) => Month(
        monthInfo: state.monthInfo,
        firstWeek: state.formatter.getFirstDayForDisplay(state.date),
        getTextForDay: state.formatter.dateText,
        isCurrentMonth: (testDate) =>
            state.formatter.isSameMonth(state.date, testDate),
        getSubTextForDay: (date, [event]) =>
            '${state.formatter.dateSubText(date) ?? ''}\n${event?.toString(date: state.calendarType == CalendarType.gregorian, use24hr: state.use24hr)}'
                .trim(),
      ),
      converter: (store) => _ViewModel(
        monthInfo: monthInfoSelector(store.state),
        date: store.state.date,
        formatter: dateFormatterSelector(store.state),
        calendarType: store.state.settings.calendarType,
        use24hr: store.state.settings.use24hr,
      ),
    );
  }
}
