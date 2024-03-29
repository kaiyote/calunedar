import 'dart:math';

import 'package:calunedar/moon_phase/julian.dart';
import 'package:calunedar/moon_phase/moon_phase.dart';
import 'package:dart_date/dart_date.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Event {
  firstQuarter,
  fullMoon,
  thirdQuarter,
  newMoon,
  vernalEquinox,
  summerSolstice,
  autumnalEquinox,
  winterSolstice,
  none
}

class DateInfo implements Comparable {
  final Event phase;
  final DateTime when;

  const DateInfo({required this.phase, required this.when});

  String toString({bool date = true, bool phase = true, bool time = true}) {
    var str = "";
    if (this.phase == Event.none) return str;

    if (date) {
      str += DateFormat.yMMMMd().format(when);
    }
    if (phase) {
      str += " " + EnumToString.convertToString(this.phase, camelCase: true);
    }
    if (time) {
      str += " at " + DateFormat.jm().format(when);
    }

    return str.trim();
  }

  bool operator ==(other) {
    if (other is! DateInfo) return false;
    return this.phase == other.phase && this.when == other.when;
  }

  @override
  int get hashCode => this.phase.hashCode + this.when.hashCode;

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
      case Event.vernalEquinox:
      case Event.autumnalEquinox:
        icon = Icons.brightness_5;
        break;
      case Event.summerSolstice:
      case Event.winterSolstice:
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
    required this.generatePinDates,
    required this.isSameMonth,
  });

  final DateTime date;
  final EventPinDates Function(DateTime date) generatePinDates;
  final bool Function(DateTime currentDate, DateTime other) isSameMonth;
  Set<DateInfo> _lunarEvents = Set();

  Set<DateInfo> get lunarEvents {
    if (_lunarEvents.isEmpty) {
      _lunarEvents = _generateLunarEvents();
    }

    return _lunarEvents;
  }

  Set<DateInfo> _generateLunarEvents() {
    var pinDates = generatePinDates(date);
    var midDate = pinDates.start
        .addDays(pinDates.end.differenceInDays(pinDates.start) ~/ 2);

    var dates = Set<DateInfo>();
    for (var date in [pinDates.start, pinDates.end, midDate]) {
      var daysBetween = date.differenceInDays(date.startOfYear);
      var yearFraction = date.year + (daysBetween / 356.25);

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

    return dates.where((element) => isSameMonth(date, element.when)).toSet();
  }
}
