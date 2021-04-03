import 'package:calunedar/app_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarAppBar extends StatelessWidget with PreferredSizeWidget {
  final DateFormat _formatter = DateFormat('MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              state.addMonths(-1);
            },
            tooltip: 'Previous Month',
          ),
          Text(
            _displayTextForCalendar(state),
            style: TextStyle(fontSize: 24.0),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              state.addMonths(1);
            },
            tooltip: 'Next Month',
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            state.toToday();
          },
          tooltip: 'To Today',
        ),
      ],
    );
  }

  String _displayTextForCalendar(AppState state) {
    switch (state.calendar) {
      case CalendarType.COLIGNY:
        return "${state.colignyDate.monthName} ${state.colignyDate.year}";
      default:
        return _formatter.format(state.date);
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}
