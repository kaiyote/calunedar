class AtticMonth {
  final DateTime startGregorian;
  final String _name;
  final bool _intercalated;
  int days;
  late int index;

  AtticMonth(
    this.startGregorian,
    this._name,
    this.days, [
    this._intercalated = false,
  ]) {
    if (days != 30 && days != 29) {
      throw RangeError('Months have only 29 or 30 days');
    }

    index = 0;
  }

  String get name => _name + (isIntercalated ? intercalatedPostfix : "");

  String get greekName =>
      monthNamesGreek[monthNames.indexOf(_name)] +
      (isIntercalated ? intercalatedGreekPostfix : "");

  bool get isHollow => days != 30;

  bool get isIntercalated => _intercalated;
}

const monthNames = <String>[
  "Hekatombaiṓn",
  "Metageitniṓn",
  "Boēdromiṓn",
  "Puanopsiṓn",
  "Maimaktēriṓn",
  "Posideiṓn",
  "Gamēliṓn",
  "Anthestēriṓn",
  "Elaphēboliṓn",
  "Mounuchiṓn",
  "Thargēliṓn",
  "Skirophoriṓn",
];

const monthNamesGreek = <String>[
  "Ἑκατομβαιών",
  "Μεταγειτνιών",
  "Βοηδρομιών",
  "Πυανοψιών",
  "Μαιμακτηριών",
  "Ποσιδειών",
  "Γαμηλιών",
  "Ἀνθεστηριών",
  "Ἑλαφηβολιών",
  "Μουνυχιών",
  "Θαργηλιών",
  "Σκιροφοριών",
];

const intercalatedPostfix = " hústeros";
const intercalatedGreekPostfix = " ὕστερος";
