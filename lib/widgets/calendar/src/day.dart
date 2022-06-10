import 'package:calunedar/redux/src/month_info.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';

class Day extends StatelessWidget {
  const Day({
    Key? key,
    required this.date,
    required this.isCurrentMonth,
    required this.event,
    required this.getTextForDay,
    required this.getSubTextForDay,
  }) : super(key: key);

  final DateTime date;
  final bool isCurrentMonth;
  final DateInfo event;
  final String Function(DateTime) getTextForDay;
  final String Function(DateTime, [DateInfo? event]) getSubTextForDay;

  @override
  Widget build(BuildContext context) {
    var isToday = date.isToday;
    var theme = Theme.of(context);

    return Expanded(
      child: AspectRatio(
        aspectRatio: 0.94,
        child: GestureDetector(
          onTap: () {
            if (getSubTextForDay(date, event).isNotEmpty) {
              final snackBar = SnackBar(
                content: Text(
                  getSubTextForDay(date, event),
                  textAlign: TextAlign.center,
                ),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(20),
              );
              final messenger = ScaffoldMessenger.of(context);

              messenger.hideCurrentSnackBar();
              messenger.showSnackBar(snackBar);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: isToday ? theme.colorScheme.secondary : Colors.black,
                width: isToday ? 3 : 1,
              ),
              color: !isCurrentMonth
                  ? theme.disabledColor
                  : theme.scaffoldBackgroundColor,
            ),
            child: _Day(
              date: date,
              isCurrentMonth: isCurrentMonth,
              event: event,
              getTextForDay: getTextForDay,
            ),
          ),
        ),
      ),
    );
  }
}

class _Day extends StatelessWidget {
  const _Day({
    Key? key,
    required this.date,
    required this.isCurrentMonth,
    required this.event,
    required this.getTextForDay,
  }) : super(key: key);

  final DateTime date;
  final bool isCurrentMonth;
  final DateInfo event;
  final String Function(DateTime) getTextForDay;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(getTextForDay(date)),
        Expanded(child: Container()),
        event.icon(
          size: width > 500
              ? 20
              : width > 400
                  ? 18
                  : 16,
        ),
      ],
    );
  }
}
