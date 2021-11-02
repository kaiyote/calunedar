class ColignyMonth {
  final String _name;
  int days;
  late int index;

  ColignyMonth(this._name, this.days) {
    if (days != 30 && days != 29) {
      throw RangeError('Months have only 29 or 30 days');
    }

    index = 0;
  }

  String get name => _name;
  String get omen => days == 30 ? 'MAT' : 'ANM';
}
