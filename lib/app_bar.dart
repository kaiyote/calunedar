import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dart_date/dart_date.dart';

class CalendarAppBar extends StatelessWidget with PreferredSizeWidget {
  CalendarAppBar({@required this.date, @required this.setDate});

  final DateTime date;
  final Function setDate;
  final DateFormat _formatter = DateFormat('MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          _formatter.format(date),
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          setDate(date.addMonths(-1));
        },
        tooltip: 'Previous Month',
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            setDate(date.addMonths(1));
          },
          tooltip: 'Next Month',
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55.0);
}
