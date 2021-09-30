import './src/month_info.dart';

abstract class DateFormatter {
  String formatForReadout(DateTime date);
  String formatForHeader(DateTime date);
  String dateText(DateTime date);
  String? dateSubText(DateTime date);
  EventPinDates generatePinDates(DateTime date);
  bool isSameMonth(DateTime testDate, DateTime otherDate);
  DateTime getFirstDayForDisplay(DateTime date);
}
