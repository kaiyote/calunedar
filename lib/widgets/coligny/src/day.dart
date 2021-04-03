import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';

import '../../gregorian/src/month_info.dart';

class Day extends StatelessWidget {
  Day({
    @required this.date,
    @required this.isCurrentMonth,
    @required this.metonic,
    this.event,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final bool metonic;
  final DateInfo event;

  @override
  Widget build(BuildContext context) {
    var isToday = date.isToday;
    var theme = Theme.of(context);

    return Expanded(
      child: AspectRatio(
        aspectRatio: 0.94,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          alignment: Alignment.center,
          child: _buildDay(),
          decoration: BoxDecoration(
            border: Border.all(
              color: isToday ? theme.accentColor : Colors.black,
              width: isToday ? 3 : 1,
            ),
            color: !isCurrentMonth
                ? theme.disabledColor
                : theme.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('${ColignyCalendar.fromDateTime(date, metonic).day}'),
        event.icon(),
      ],
    );
  }
}
