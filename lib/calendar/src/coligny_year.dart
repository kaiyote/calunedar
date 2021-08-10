import 'coligny_month.dart';

class ColignyYear {
  final int _year;
  final bool _metonic;
  late List<ColignyMonth> _months;
  late int _ident;
  late int _yearDays;

  ColignyYear(this._year, [this._metonic = false]) {
    _months = <ColignyMonth>[
      ColignyMonth('Samonios', 30),
      ColignyMonth('Dumanios', 29),
      ColignyMonth('Riuros', 30),
      ColignyMonth('Anagantios', 29),
      ColignyMonth('Ogronios', 30),
      ColignyMonth('Cutios', 30),
      ColignyMonth('Giamonios', 29),
      ColignyMonth('Simiuisonna', 30),
      ColignyMonth('Elembi', 29),
      ColignyMonth('Aedrinni', 30),
      ColignyMonth('Cantlos', 29),
    ];

    _ident = _metonic
        ? _metonicMap[(_year - 4999) % 19]!
        : _saturnMap[(_year - 4998) % 5]!;

    final saturnCycleYear = (_year - 4998) % 30;

    switch (_ident) {
      case 1:
        _months.insert(0, ColignyMonth('Quimonios', 29));
        _months.insert(8, ColignyMonth('Equos', 30));
        break;
      case 3:
        _months.insert(8, ColignyMonth('Equos', 29));
        if (_metonic || (saturnCycleYear != 27 && saturnCycleYear != -3)) {
          _months.insert(6, ColignyMonth('Rantaranos', 30));
        }
        break;
      case 5:
        _months.insert(8, ColignyMonth('Equos', 30));
        break;
      default:
        _months.insert(8, ColignyMonth('Equos', 29));
        break;
    }

    if (_metonic) {
      final absYear = (_year - 4999).abs();
      if (absYear >= 60.97 && absYear % 60.97 <= 5 && _ident == 5) {
        _months[8].days = 29;
      }

      if (absYear > 6568.62 && absYear % 6568.62 <= 5 && _ident == 3) {
        _months.removeAt(6);
      }
    } else {
      final absYear = (_year - 4998).abs();
      if (absYear >= 197.97 && absYear % 197.97 <= 5 && _ident == 5) {
        _months[8].days = 29;
      }

      if (absYear > 635.04 &&
          absYear % 635.04 <= 30 &&
          (saturnCycleYear == 27 || saturnCycleYear == -3)) {
        _months.insert(6, ColignyMonth('Rantaranos', 30));
      }
    }

    _yearDays = 0;

    for (int i = 0; i < _months.length; i++) {
      _months[i].index = i;
      _yearDays += _months[i].days;
    }
  }

  int get year => _year;
  bool get metonic => _metonic;
  List<ColignyMonth> get months => _months;
  int get daysInYear => _yearDays;
  int get ident => _ident;

  static Map<int, int> _metonicMap = {
    -18: 3,
    -17: 4,
    -16: 5,
    -15: 1,
    -14: 2,
    -13: 3,
    -12: 4,
    -11: 5,
    -10: 1,
    -9: 2,
    -8: 3,
    -7: 4,
    -6: 5,
    -5: 1,
    -4: 2,
    -3: 3,
    -2: 4,
    -1: 5,
    0: 2,
    1: 3,
    2: 4,
    3: 5,
    4: 1,
    5: 2,
    6: 3,
    7: 4,
    8: 5,
    9: 1,
    10: 2,
    11: 3,
    12: 4,
    13: 5,
    14: 1,
    15: 2,
    16: 3,
    17: 4,
    18: 5
  };

  static Map<int, int> _saturnMap = {
    -4: 2,
    -3: 3,
    -2: 4,
    -1: 5,
    0: 1,
    1: 2,
    2: 3,
    3: 4,
    4: 5
  };
}
