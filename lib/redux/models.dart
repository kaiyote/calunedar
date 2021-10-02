import 'package:calunedar/redux/date_formatter.dart';
import 'package:calunedar/redux/src/coligny_date_formatter.dart';
import 'package:calunedar/redux/src/gregorian_date_formatter.dart';
import 'package:calunedar/redux/src/month_info.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reselect/reselect.dart';

class AppState {
  AppState({
    this.settings = const Settings(),
    this.showScrollToEvents = false,
    DateTime? date,
    this.position,
  }) : date = date ?? DateTime.now();

  final Settings settings;
  final DateTime date;
  final Position? position;
  final bool showScrollToEvents;

  AppState copyWith({
    Settings? settings,
    DateTime? date,
    Position? position,
    bool? showScrollToEvents,
  }) =>
      AppState(
        settings: settings ?? this.settings,
        date: date ?? this.date,
        showScrollToEvents: showScrollToEvents ?? this.showScrollToEvents,
        position: position ?? this.position,
      );

  static AppState fromJson(dynamic json) {
    if (json == null) return AppState();

    return AppState(settings: Settings.fromJson(json['settings']));
  }

  dynamic toJson() {
    return {'settings': settings.toJson()};
  }
}

enum CalendarType {
  gregorian,
  coligny,
}

class Settings {
  const Settings({
    this.calendarType = CalendarType.gregorian,
    this.metonic = true,
    this.use24hr = false,
  });

  final CalendarType calendarType;
  final bool metonic;
  final bool use24hr;

  Settings copyWith({
    CalendarType? calendarType,
    bool? metonic,
    bool? use24hr,
  }) =>
      Settings(
        calendarType: calendarType ?? this.calendarType,
        metonic: metonic ?? this.metonic,
        use24hr: use24hr ?? this.use24hr,
      );

  static Settings fromJson(dynamic json) {
    if (json == null) return const Settings();

    return Settings(
      calendarType: CalendarType.values.firstWhere(
        (e) => describeEnum(e) == json['calendarType'],
        orElse: () => CalendarType.gregorian,
      ),
      metonic: json['metonic'],
      use24hr: json['use24hr'],
    );
  }

  dynamic toJson() => {
        'calendarType': describeEnum(calendarType),
        'metonic': metonic,
        'use24hr': use24hr,
      };
}

///
/// Selectors
///
CalendarType calendarTypeSelector(AppState state) =>
    state.settings.calendarType;

bool metonicSelector(AppState state) => state.settings.metonic;

bool use24hrSelector(AppState state) => state.settings.use24hr;

DateTime dateSelector(AppState state) => state.date;

Position? positionSelector(AppState state) => state.position;

final dateFormatterSelector =
    createSelector3<AppState, CalendarType, bool, bool, DateFormatter>(
  calendarTypeSelector,
  metonicSelector,
  use24hrSelector,
  (type, metonic, use24hr) {
    switch (type) {
      case CalendarType.coligny:
        return ColignyDateFormatter(metonic, use24hr);
      case CalendarType.gregorian:
        return GregorianDateFormatter(use24hr);
    }
  },
);

final monthInfoSelector =
    createSelector3<AppState, DateFormatter, DateTime, Position?, MonthInfo>(
  dateFormatterSelector,
  dateSelector,
  positionSelector,
  (formatter, date, position) => MonthInfo(
    date: date,
    dateFormatter: formatter,
    position: position ??
        Position(
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
        ),
  ),
);
