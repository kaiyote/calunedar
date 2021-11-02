class AtticMonth {
  final String _name;
  int days;
  late int index;

  AtticMonth(this._name, this.days) {
    if (days != 30 && days != 29) {
      throw RangeError('Months have only 29 or 30 days');
    }

    index = 0;
  }

  String get name => _name;

  String get greekName => monthNamesGreek[monthNames.indexOf(_name)];

  bool get isHollow => days != 30;
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
