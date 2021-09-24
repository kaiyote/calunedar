import 'attic_month.dart';

class AtticYear {
  final int _year;
  late List<AtticMonth> _months;
  late int _yearDays;

  AtticYear(this._year) {
    _months = <AtticMonth>[
      AtticMonth('Samonios', 30),
      AtticMonth('Dumanios', 29),
      AtticMonth('Riuros', 30),
      AtticMonth('Anagantios', 29),
      AtticMonth('Ogronios', 30),
      AtticMonth('Cutios', 30),
      AtticMonth('Giamonios', 29),
      AtticMonth('Simiuisonna', 30),
      AtticMonth('Elembi', 29),
      AtticMonth('Aedrinni', 30),
      AtticMonth('Cantlos', 29),
    ];

    _yearDays = 0;

    for (int i = 0; i < _months.length; i++) {
      _months[i].index = i;
      _yearDays += _months[i].days;
    }
  }

  int get year => _year;
  List<AtticMonth> get months => _months;
  int get daysInYear => _yearDays;
}
