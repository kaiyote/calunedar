import 'package:calunedar/widgets/calendar/src/month_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './settings.dart';

class AppState with ChangeNotifier {
  DateTime _date;
  bool _showActionButton;
  CalendarType? _calendar;
  MonthInfo? _monthInfo;
  final String license;

  AppState(this.license)
      : _date = DateTime.now(),
        _showActionButton = false;

  DateTime get date => _date;
  bool get showActionButton => _showActionButton;

  MonthInfo monthInfo(BuildContext context) {
    final currentCalendar =
        Provider.of<Settings>(context, listen: false).calendar;
    final dateFormatter =
        Provider.of<Settings>(context, listen: false).dateFormatter(context);

    if (_calendar != currentCalendar || _monthInfo?.date != _date) {
      _calendar = currentCalendar;
      _monthInfo = MonthInfo(
        date: _date,
        generatePinDates: dateFormatter.generatePinDates,
        isSameMonth: dateFormatter.isSameMonth,
      );
    }

    return _monthInfo!;
  }

  set date(DateTime date) {
    _date = date;
    notifyListeners();
  }

  set showActionButton(bool showActionButton) {
    _showActionButton = showActionButton;
    notifyListeners();
  }

  void toToday() {
    _date = DateTime.now();
    notifyListeners();
  }
}
