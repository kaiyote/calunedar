import 'package:calunedar/redux/src/month_info.dart';
import 'package:flutter/material.dart';

class ReadoutImpl extends StatelessWidget {
  const ReadoutImpl({
    Key? key,
    required this.monthInfo,
    required this.formatDate,
    required this.formatEvent,
  }) : super(key: key);

  final MonthInfo monthInfo;
  final String Function(DateTime) formatDate;
  final String Function(DateInfo) formatEvent;

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
                  formatEvent(dateInfo),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: dateInfo.icon(),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              formatDate(dateInfo.when),
              style: const TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
