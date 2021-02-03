import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';
import 'package:meeus/moonphase.dart';
import 'package:meeus/julian.dart';

class Day extends StatelessWidget {
  Day({@required this.date, @required this.isCurrentMonth});

  final DateTime date;
  final bool isCurrentMonth;

  @override
  Widget build(BuildContext context) {
    var isToday = date.isToday;
    var theme = Theme.of(context);

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          alignment: Alignment.center,
          child: _buildDayInfo(date, theme),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            color: isToday
                ? theme.accentColor
                : !isCurrentMonth
                    ? theme.disabledColor
                    : theme.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDayInfo(DateTime date, ThemeData theme) {
    var daysBetween = date.differenceInDays(date.startOfYear);
    var yearFraction = date.year + (daysBetween / 356.25);
    var isFirst = jdToDateTime(first(yearFraction)).isSameDay(date);
    var isFull = jdToDateTime(full(yearFraction)).isSameDay(date);
    var isThird = jdToDateTime(last(yearFraction)).isSameDay(date);
    var isNew = jdToDateTime(newMoon(yearFraction)).isSameDay(date);

    var label = isFirst
        ? 'First Quarter'
        : isFull
            ? 'Full Moon'
            : isThird
                ? 'Third Quarter'
                : isNew
                    ? 'New Moon'
                    : '';

    return Column(
      children: [
        Text(
          '${date.getDate}',
          style: TextStyle(
            color: isCurrentMonth
                ? theme.textTheme.bodyText1.color
                : theme.textTheme.bodyText2.color,
          ),
        ),
        Text(label),
      ],
    );
  }
}
