import 'attic_month.dart';

// TODO
class AtticYear {
  final int _year;
  late List<AtticMonth> _months;
  late int _yearDays;

  AtticYear(this._year) {
    _months = <AtticMonth>[
      AtticMonth('Hekatombaiṓn', 30),
      AtticMonth('Metageitniṓn', 29),
      AtticMonth('Boēdromiṓn', 30),
      AtticMonth('Puanopsiṓn', 29),
      AtticMonth('Maimaktēriṓn', 30),
      AtticMonth('Posideiṓn', 30),
      AtticMonth('Gamēliṓn', 29),
      AtticMonth('Anthestēriṓn', 30),
      AtticMonth('Elaphēboliṓn', 29),
      AtticMonth('Mounuchiṓn', 30),
      AtticMonth('Thargēliṓn', 29),
      AtticMonth('Skirophoriṓn', 30)
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
