import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

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
          child: Text(
            '${date.getDate}',
            style: TextStyle(
              color: isCurrentMonth
                  ? theme.textTheme.bodyText1.color
                  : theme.textTheme.bodyText2.color,
            ),
          ),
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
}
