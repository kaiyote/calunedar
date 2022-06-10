import 'dart:math';

import 'package:calunedar/celestial_math/julian.dart';
import 'package:calunedar/celestial_math/moon_phase.dart';
import 'package:calunedar/celestial_math/solar_event.dart';
import 'package:calunedar/redux/date_formatter.dart';
import 'package:dart_date/dart_date.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:solar_calculator/solar_calculator.dart';

enum Event {
  firstQuarter,
  fullMoon,
  thirdQuarter,
  newMoon,
  marchEquinox,
  juneSolstice,
  septemberEquinox,
  decemberSolstice,
  none
}

class DateInfo implements Comparable {
  const DateInfo({
    required this.when,
    this.phase = Event.none,
    this.sunsetTime,
  });

  final DateTime when;
  final Event phase;
  final Instant? sunsetTime;

  @override
  String toString({
    bool date = true,
    bool phase = true,
    bool time = true,
    bool use24hr = false,
  }) {
    var str = "";

    if (this.phase == Event.none) return "";

    if (date) {
      str += DateFormat.yMMMMd().format(when);
    }
    if (phase) {
      str += " ${EnumToString.convertToString(this.phase, camelCase: true)}";
    }
    if (time) {
      str +=
          " at ${(use24hr ? DateFormat.Hm() : DateFormat.jm()).format(when)} ${DateFormatter.timeZoneAbbr(when)}";
    }

    return str.trim();
  }

  @override
  bool operator ==(other) {
    if (other is! DateInfo) return false;
    return phase == other.phase && when == other.when;
  }

  @override
  int get hashCode => phase.hashCode + when.hashCode;

  @override
  int compareTo(other) => when.compareTo(other.when);

  Widget icon({double size = 20.0}) {
    IconData icon;

    switch (phase) {
      case Event.firstQuarter:
      case Event.thirdQuarter:
        icon = Icons.brightness_2;
        break;
      case Event.fullMoon:
        icon = Icons.brightness_1_outlined;
        break;
      case Event.newMoon:
        icon = Icons.brightness_1;
        break;
      case Event.marchEquinox:
      case Event.septemberEquinox:
        icon = Icons.brightness_5;
        break;
      case Event.juneSolstice:
      case Event.decemberSolstice:
        icon = Icons.brightness_7;
        break;
      case Event.none:
        icon = Icons.minimize;
        break;
    }

    return Transform.rotate(
      angle: phase == Event.thirdQuarter ? pi : 0.0,
      child: phase == Event.none ? null : Icon(icon, size: size),
    );
  }
}

class EventPinDates {
  EventPinDates({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

class MonthInfo {
  MonthInfo({
    required this.date,
    required this.dateFormatter,
    required this.position,
  }) : lunarEvents = _generateLunarEvents(date, dateFormatter, position);

  final DateTime date;
  final DateFormatter dateFormatter;
  final Position position;
  final Set<DateInfo> lunarEvents;

  static Set<DateInfo> _generateLunarEvents(
    DateTime date,
    DateFormatter dateFormatter,
    Position position,
  ) {
    var pinDates = dateFormatter.generatePinDates(date);
    var midDate = pinDates.start
        .addDays(pinDates.end.differenceInDays(pinDates.start) ~/ 2, true);

    var dates = <DateInfo>{};
    pinDates.end.eachDay(pinDates.start).forEach((date) {
      final calcForDay = SolarCalculator(
        Instant.fromDateTime(date.startOfDay.addHours(12, true)),
        position.latitude,
        position.longitude,
      );

      dates.add(DateInfo(
        when: date,
        sunsetTime: calcForDay.sunsetTime,
      ));
    });

    for (final date in [pinDates.start, midDate, pinDates.end]) {
      final daysBetween = date.differenceInDays(date.startOfYear);
      final yearFraction = date.year + (daysBetween / 356.25);

      dates.add(DateInfo(
        phase: Event.firstQuarter,
        when: jdToDateTime(first(yearFraction)).local,
      ));
      dates.add(DateInfo(
        phase: Event.fullMoon,
        when: jdToDateTime(full(yearFraction)).local,
      ));
      dates.add(DateInfo(
        phase: Event.thirdQuarter,
        when: jdToDateTime(last(yearFraction)).local,
      ));
      dates.add(DateInfo(
        phase: Event.newMoon,
        when: jdToDateTime(newMoon(yearFraction)).local,
      ));
    }

    for (final year in [pinDates.start.year, pinDates.end.year]) {
      dates.add(DateInfo(
        phase: Event.marchEquinox,
        when: marchEquinox(position, year).toUtcDateTime().local,
      ));
      dates.add(DateInfo(
        phase: Event.juneSolstice,
        when: juneSolstice(position, year).toUtcDateTime().local,
      ));
      dates.add(DateInfo(
        phase: Event.septemberEquinox,
        when: septemberEquinox(position, year).toUtcDateTime().local,
      ));
      dates.add(DateInfo(
        phase: Event.decemberSolstice,
        when: decemberSolstice(position, year).toUtcDateTime().local,
      ));
    }

    return dates
        .where((element) => dateFormatter.isSameMonth(date, element.when))
        .toSet();
  }
}
