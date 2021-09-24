import 'package:calunedar/state/location_service.dart';
import 'package:calunedar/widgets/calendar/src/month_info.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:dart_date/dart_date.dart';

import './settings.dart';

class AppState with ChangeNotifier {
  DateTime _date;
  bool _showActionButton;
  CalendarType? _calendar;
  MonthInfo? _monthInfo;
  Position? _position;

  AppState()
      : _date = DateTime.now(),
        _showActionButton = false;

  DateTime get date => _date;
  bool get showActionButton => _showActionButton;
  Future<Position?> get location async {
    if (_position?.timestamp == null ||
        _position!.timestamp! <= DateTime.now().subDays(1)) {
      _position = await getPosition().catchError((e, __) {
        return Position(
          // literally in the middle of the atlantic off the coast of
          // sub-saharan africa
          // when i get around to mathing out day-start-at-sundown gonna need
          // to alert to this fact somewhere, since sunset will likely be
          // significantly off from where the user really is
          longitude: 0.0,
          latitude: 0.0,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
      });
    }
    return _position;
  }

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
