import 'package:calunedar/widgets/month_info/month_info.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

class Day extends StatelessWidget {
  Day({@required this.date, @required this.isCurrentMonth, this.event});

  final DateTime date;
  final bool isCurrentMonth;
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
        Text('${date.getDate}'),
        event.icon(),
      ],
    );
  }
}
