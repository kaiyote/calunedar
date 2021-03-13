import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SETTINGS_KEY = "calunedar_settings";

enum CalendarType {
  GREGORIAN,
  COLIGNY,
}

class Settings with ChangeNotifier {
  Color _primaryColor;
  CalendarType _calendar;
  MaterialColor _colorSwatch;
  bool _metonic;

  Settings(
      [this._primaryColor,
      this._calendar = CalendarType.GREGORIAN,
      this._metonic = true]) {
    this._primaryColor = this._primaryColor ?? Colors.cyan.shade500;
    this._colorSwatch = Settings._createMaterialColor(this._primaryColor);
  }

  Color get primaryColor => _primaryColor;

  CalendarType get calendar => _calendar;

  MaterialColor get colorSwatch => _colorSwatch;

  bool get metonic => _metonic;

  set primaryColor(Color newPrimary) {
    this._primaryColor = newPrimary;
    this._colorSwatch = Settings._createMaterialColor(newPrimary);

    _persistChanges();
  }

  set calendar(CalendarType newCalendar) {
    this._calendar = newCalendar;

    _persistChanges();
  }

  set metonic(bool metonic) {
    this._metonic = metonic;

    _persistChanges();
  }

  _persistChanges() async {
    var prefs = await SharedPreferences.getInstance();
    notifyListeners();
    prefs.setString(SETTINGS_KEY, jsonEncode(this));
  }

  static _createMaterialColor(Color primaryColor) {
    List strengths = <double>[0.05];
    Map swatch = <int, Color>{};
    final int r = primaryColor.red,
        g = primaryColor.green,
        b = primaryColor.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });

    return MaterialColor(primaryColor.value, swatch);
  }

  Settings.fromJson(Map<String, dynamic> json)
      : _primaryColor = Color(json['primaryColor']),
        _metonic = json['metonic'],
        _calendar = CalendarType.values.firstWhere(
          (e) => describeEnum(e) == json['calendar'],
        ),
        _colorSwatch = Settings._createMaterialColor(
          Color(json['primaryColor']),
        );

  Map<String, dynamic> toJson() => {
        'primaryColor': _primaryColor.value,
        'calendar': describeEnum(_calendar),
        'metonic': _metonic
      };
}
