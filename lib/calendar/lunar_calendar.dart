abstract class LunarCalendar implements Comparable<LunarCalendar> {
  /// 1 based month
  int get month;

  /// 1 based day
  int get day;

  /// implementation defined year
  int get year;

  /// number of days in the year
  int get yearLength;

  /// implementation defined day of the week
  int get weekday;

  /// the day of the year
  int get dayOfYear;

  /// add a week to the LunarCalendar
  addWeeks(int weeks);

  /// add a day to the LunarCalendar
  addDays(int days);

  /// add a month to the lunar calendar
  addMonths(int months);

  /// add a year to the lunar calendar
  addYears(int years);

  /// Produce an ISO8601 formatted date string
  String toIS08601String();

  /// produce a unique integer representation o fthis date
  int toInt();

  /// produce a DateTime at 0:0:0 in the gregorian calendar
  DateTime toDateTime();

  copy();
}
