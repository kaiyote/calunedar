import 'dart:convert';

import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SETTINGS_KEY = "calunedar_settings";

enum CalendarType {
  GREGORIAN,
  COLIGNY,
}

class AppState with ChangeNotifier {
  CalendarType _calendar;
  bool _metonic;
  DateTime _date;
  ColignyCalendar _colignyDate;

  AppState([this._calendar = CalendarType.GREGORIAN, this._metonic = true]) {
    _date = DateTime.now();
    _colignyDate = ColignyCalendar.fromDateTime(_date, _metonic);
  }

  CalendarType get calendar => _calendar;

  bool get metonic => _metonic;

  DateTime get date => _date;

  ColignyCalendar get colignyDate => _colignyDate;

  set calendar(CalendarType newCalendar) {
    _calendar = newCalendar;

    _persistChanges();
  }

  set metonic(bool metonic) {
    _metonic = metonic;
    _colignyDate = ColignyCalendar.fromDateTime(date, metonic);

    _persistChanges();
  }

  set date(DateTime date) {
    _date = date;
    _colignyDate = ColignyCalendar.fromDateTime(date, metonic);
    notifyListeners();
  }

  set colignyDate(ColignyCalendar colignyDate) {
    _colignyDate = colignyDate;
    _date = colignyDate.toDateTime();
    notifyListeners();
  }

  void toToday() {
    _date = DateTime.now();
    _colignyDate = ColignyCalendar.fromDateTime(date, metonic);
    notifyListeners();
  }

  void _persistChanges() async {
    var prefs = await SharedPreferences.getInstance();
    notifyListeners();
    prefs.setString(SETTINGS_KEY, jsonEncode(this));
  }

  AppState.fromJson(Map<String, dynamic> json)
      : this(
          CalendarType.values.firstWhere(
            (e) => describeEnum(e) == json['calendar'],
          ),
          json['metonic'],
        );

  Map<String, dynamic> toJson() => {
        'calendar': describeEnum(_calendar),
        'metonic': _metonic,
      };
}
