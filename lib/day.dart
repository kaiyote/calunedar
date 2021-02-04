import 'package:coligny_calendar/month.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

class Day extends StatelessWidget {
  Day({
    @required this.date,
    @required this.isCurrentMonth,
    @required this.event,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final MoonInfo event;

  @override
  Widget build(BuildContext context) {
    var isToday = date.isToday;
    var theme = Theme.of(context);

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          alignment: Alignment.center,
          child: _buildDayInfo(theme),
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

  Widget _buildDayInfo(ThemeData theme) {
    var label = event.phase == Phase.first
        ? 'First Quarter'
        : event.phase == Phase.full
            ? 'Full Moon'
            : event.phase == Phase.third
                ? 'Third Quarter'
                : event.phase == Phase.newMoon
                    ? 'New Moon'
                    : '';

    return Column(
      children: [
        Text('${date.getDate}'),
        Text(label),
      ],
    );
  }
}
