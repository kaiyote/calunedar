import 'package:calunedar/celestial_event.dart';
import 'package:calunedar/month_info.dart';
import 'package:flutter/material.dart';

class MonthReadout extends StatelessWidget {
  MonthReadout({this.monthInfo});

  final MonthInfo monthInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: _buildInfo(),
      ),
    );
  }

  List<Widget> _buildInfo() {
    var sortedEvents = List.from(monthInfo.lunarEvents);
    sortedEvents.sort();

    var events = sortedEvents
        .map<Widget>((dateInfo) => CelestialEvent(event: dateInfo))
        .toList();

    events.insert(
      0,
      Text(
        'Celestial Events',
        style: TextStyle(fontSize: 24.0),
      ),
    );

    return events;
  }
}
