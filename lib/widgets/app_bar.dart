import 'package:calunedar/settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dart_date/dart_date.dart';
import 'package:calunedar/coligny.dart';
import 'package:provider/provider.dart';

class CalendarAppBar extends StatelessWidget with PreferredSizeWidget {
  CalendarAppBar({@required this.date, @required this.setDate});

  final DateTime date;
  final Function setDate;
  final DateFormat _formatter = DateFormat('MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setDate(date.addMonths(-1));
              },
              tooltip: 'Previous Month',
            ),
            Text(
              _displayTextForCalendar(settings.calendar, settings.metonic),
              style: TextStyle(fontSize: 24.0),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                setDate(date.addMonths(1));
              },
              tooltip: 'Next Month',
            ),
          ],
        ),
      );
    });
  }

  String _displayTextForCalendar(CalendarType calendar, bool metonic) {
    switch (calendar) {
      case CalendarType.COLIGNY:
        final coligny = date.toColignyDate(metonic);
        return "${coligny.month.name} ${coligny.year}";
      default:
        return _formatter.format(date);
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}
