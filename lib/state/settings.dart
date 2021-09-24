import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './date_formatter.dart';
import './src/coligny_date_formatter.dart';
import './src/gregorian_date_formatter.dart';

const settingsKey = "calunedar_settings";

enum CalendarType {
  gregorian,
  coligny,
}

class Settings with ChangeNotifier {
  CalendarType _calendar;
  bool _metonic;
  DateFormatter? _dateFormatter;

  Settings([this._calendar = CalendarType.gregorian, this._metonic = true]);

  CalendarType get calendar => _calendar;

  bool get metonic => _metonic;

  DateFormatter dateFormatter(BuildContext context) {
    if (!_checkDateFormater()) {
      switch (_calendar) {
        case CalendarType.coligny:
          _dateFormatter = ColignyDateFormatter(context, _metonic);
          break;
        default:
          _dateFormatter = GregorianDateFormatter(context);
      }
    }

    return _dateFormatter!;
  }

  bool _checkDateFormater() =>
      (_calendar == CalendarType.coligny &&
          _dateFormatter is ColignyDateFormatter) ||
      (_calendar == CalendarType.gregorian &&
          _dateFormatter is GregorianDateFormatter);

  set calendar(CalendarType newCalendar) {
    _calendar = newCalendar;

    _persistChanges();
    notifyListeners();
  }

  set metonic(bool metonic) {
    _metonic = metonic;

    _persistChanges();
    notifyListeners();
  }

  void _persistChanges() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(settingsKey, jsonEncode(this));
  }

  Settings.fromJson(Map<String, dynamic> json)
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
