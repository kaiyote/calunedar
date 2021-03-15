import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calunedar/settings.dart';

void main() {
  group('Settings', () {
    test('It will init correctly w/ default values', () {
      var settings = Settings();

      expect(settings.calendar, equals(CalendarType.GREGORIAN));
      expect(settings.primaryColor, equals(Colors.cyan.shade500));
    });

    test('It will init w/ custom values', () {
      var settings = Settings(Color(0xff00ff00), CalendarType.COLIGNY);

      expect(settings.calendar, equals(CalendarType.COLIGNY));
      expect(settings.primaryColor, equals(Color(0xff00ff00)));
    });

    test('It will serialize to json as expected', () {
      var settings = Settings(Color(0xff00ff00), CalendarType.COLIGNY);

      var settingsMap = settings.toJson();

      expect(settingsMap['primaryColor'], equals(0xff00ff00));
      expect(settingsMap['calendar'], equals('COLIGNY'));
    });

    test('It will deserialize correctly from a string', () {
      var jsonString =
          jsonEncode(Settings(Color(0xff00ff00), CalendarType.COLIGNY));

      var rehydratedSettings = Settings.fromJson(jsonDecode(jsonString));

      expect(rehydratedSettings.primaryColor, equals(Color(0xff00ff00)));
      expect(rehydratedSettings.calendar, equals(CalendarType.COLIGNY));
    });
  });
}
