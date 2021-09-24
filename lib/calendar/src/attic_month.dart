class AtticMonth {
  final String _name;
  int days;
  late int index;

  AtticMonth(this._name, this.days) {
    if (days != 30 && days != 29) {
      throw RangeError('Months only have 29 or 30 days');
    }

    index = 0;
  }

  String get name => _name;
  bool get isHollow => days != 30;
}
