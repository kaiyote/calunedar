import 'package:calunedar/celestial_math/solar_event.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dart_date/dart_date.dart';

import 'attic_month.dart';

class AtticYear {
  final int _year;
  final Position _position;
  late List<AtticMonth> _months;
  late int _yearDays;

  AtticYear(this._year, this._position) {
    final visibleMoons = visibleNewMoonsForYear(
      juneSolstice(position, year),
      position,
    );
    // the function ships one extra for counting days of last month
    // so 13 for regular years, 14 for intercalated ones
    final needsIntercalation = visibleMoons.length > 13;

    _months = visibleMoons
        .take(visibleMoons.length - 1)
        .toList()
        .asMap()
        .entries
        .map<AtticMonth>(
      (entry) {
        // doing it inHours / 24 and rounded instead of inDays because fuk DST
        final length =
            (visibleMoons[entry.key + 1].difference(entry.value).inHours / 24)
                .round();

        final monthName = _nameForMonthIndex(entry.key, needsIntercalation);

        final month = AtticMonth(
          entry.value,
          monthName,
          length,
          needsIntercalation && entry.key == 6,
        );
        month.index = entry.key;

        return month;
      },
    ).toList();

    _yearDays = visibleMoons.first.differenceInDays(visibleMoons.last).abs();
  }

  _nameForMonthIndex(int month, bool requiresIntercalation) {
    return month < 6
        ? monthNames[month]
        : requiresIntercalation
            ? monthNames[month - 1]
            : monthNames[month];
  }

  int get year => _year;
  List<AtticMonth> get months => _months;
  int get daysInYear => _yearDays;
  Position get position => _position;
}
