import './src/month_info.dart';

abstract class DateFormatter {
  String formatForReadout(DateTime date);
  String formatForHeader(DateTime date);
  String dateText(DateTime date);
  String? dateSubText(DateTime date);
  EventPinDates generatePinDates(DateTime date);
  bool isSameMonth(DateTime testDate, DateTime otherDate);
  DateTime getFirstDayForDisplay(DateTime date);
  String formatEvent(DateInfo event);

  static timeZoneAbbr(DateTime date) =>
      date.timeZoneName.replaceAll(RegExp('[a-z ]'), '');
}
