import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

import 'month_info.dart';

class ReadoutImpl extends StatelessWidget {
  ReadoutImpl({
    required this.monthInfo,
    required this.formatDate,
  });

  final MonthInfo monthInfo;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
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
          _buildInfo()
        ],
      ),
    );
  }

  Widget _buildInfo() {
    var sortedEvents = List.from(monthInfo.lunarEvents);
    sortedEvents.sort();

    return Table(
      border: TableBorder.all(style: BorderStyle.none),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: sortedEvents
          .map<TableRow>((dateInfo) => _buildRow(dateInfo: dateInfo))
          .toList(),
    );
  }

  TableRow _buildRow({required DateInfo dateInfo}) {
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
              formatDate(dateInfo.when.toLocal()),
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
