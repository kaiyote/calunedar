import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calunedar/app_state.dart';

void main() {
  group('Settings', () {
    test('It will init correctly w/ default values', () {
      var settings = AppState();

      expect(settings.calendar, equals(CalendarType.GREGORIAN));
    });

    test('It will init w/ custom values', () {
      var settings = AppState(CalendarType.COLIGNY);

      expect(settings.calendar, equals(CalendarType.COLIGNY));
    });

    test('It will serialize to json as expected', () {
      var settings = AppState(CalendarType.COLIGNY);

      var settingsMap = settings.toJson();

      expect(settingsMap['calendar'], equals('COLIGNY'));
    });

    test('It will deserialize correctly from a string', () {
      var jsonString = jsonEncode(AppState(CalendarType.COLIGNY));

      var rehydratedSettings = AppState.fromJson(jsonDecode(jsonString));

      expect(rehydratedSettings.calendar, equals(CalendarType.COLIGNY));
    });
  });
}
