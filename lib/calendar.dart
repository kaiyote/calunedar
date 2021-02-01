import 'package:coligny_calendar/month.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dart_date/dart_date.dart';

class Calendar extends StatefulWidget {
  Calendar({Key key, this.startDate}) : super(key: key);

  final DateTime startDate;

  @override
  _CalendarState createState() => _CalendarState(startDate ?? Date.today);
}

class _CalendarState extends State<Calendar> {
  _CalendarState(this.date);

  DateTime date;
  final DateFormat _formatter = DateFormat('MMMM yyyy');

  void _addMonth(int month) {
    setState(() {
      date = date.addMonths(month);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(_formatter.format(date)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _addMonth(-1);
          },
          tooltip: 'Previous Month',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              _addMonth(1);
            },
            tooltip: 'Next Month',
          )
        ],
      ),
      body: Month(date: date),
    );
  }
}
