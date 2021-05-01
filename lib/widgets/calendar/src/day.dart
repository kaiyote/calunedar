import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';

import 'month_info.dart';

class Day extends StatelessWidget {
  Day({
    @required this.date,
    @required this.isCurrentMonth,
    @required this.event,
    @required this.getTextForDay,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final DateInfo event;
  final String Function(DateTime) getTextForDay;

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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(getTextForDay(date)),
        Expanded(child: Container()),
        event.icon(),
      ],
    );
  }
}
