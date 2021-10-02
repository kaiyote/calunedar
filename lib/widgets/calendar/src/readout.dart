import 'package:calunedar/redux/src/month_info.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

class ReadoutImpl extends StatelessWidget {
  const ReadoutImpl({
    Key? key,
    required this.monthInfo,
    required this.formatDate,
  }) : super(key: key);

  final MonthInfo monthInfo;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: const Text(
            'Celestial Events',
            style: TextStyle(fontSize: 24.0),
          ),
        ),
        _buildInfo()
      ],
    );
  }

  Widget _buildInfo() {
    var events = List<DateInfo>.from(
      monthInfo.lunarEvents.where(
        (element) => element.phase != Event.none,
      ),
    );
    events.sort();

    return Table(
      border: TableBorder.all(style: BorderStyle.none),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: events
          .map<TableRow>((dateInfo) => _buildRow(dateInfo: dateInfo))
          .toList(),
    );
  }

  TableRow _buildRow({required DateInfo dateInfo}) {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              children: [
                Text(
                  EnumToString.convertToString(dateInfo.phase, camelCase: true),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  child: dateInfo.icon(),
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              formatDate(dateInfo.when.toLocal()),
              style: const TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
