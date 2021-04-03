import 'package:calunedar/app_state.dart';
import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'month_info.dart';

class Readout extends StatelessWidget {
  Readout({this.monthInfo});

  final MonthInfo monthInfo;
  final _dateFormatter = DateFormat.jm();

  @override
  Widget build(BuildContext context) {
    final metonic = context.select<AppState, bool>((state) => state.metonic);

    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(
              'Celestial Events',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          _buildInfo(metonic: metonic)
        ],
      ),
    );
  }

  Widget _buildInfo({bool metonic}) {
    var sortedEvents = List.from(monthInfo.lunarEvents);
    sortedEvents.sort();

    return Table(
      border: TableBorder.all(style: BorderStyle.none),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: sortedEvents
          .map<TableRow>(
              (dateInfo) => _buildRow(dateInfo: dateInfo, metonic: metonic))
          .toList(),
    );
  }

  TableRow _buildRow({DateInfo dateInfo, bool metonic}) {
    final colignyDate =
        ColignyCalendar.fromDateTime(dateInfo.when.toLocal(), metonic);

    return TableRow(
      children: [
        TableCell(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              children: [
                Text(
                  EnumToString.convertToString(dateInfo.phase, camelCase: true),
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  child: dateInfo.icon(),
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              '${colignyDate.monthName} ${colignyDate.day} at ${_dateFormatter.format(dateInfo.when.toLocal())}',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
