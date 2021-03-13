import 'package:calunedar/widgets/month_info.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CelestialEvent extends StatelessWidget {
  CelestialEvent({@required this.event});

  final DateInfo event;
  final _dateFormatter = DateFormat.MMMMd().addPattern('\'at\'').add_jm();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTitle(),
          _buildDateString(),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          EnumToString.convertToString(event.phase, camelCase: true),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          child: event.icon(),
          margin: EdgeInsets.symmetric(vertical: 5.0),
        ),
      ],
    );
  }

  Widget _buildDateString() {
    return Text(
      _dateFormatter.format(event.when.toLocal()),
      style: TextStyle(fontSize: 16.0),
    );
  }
}
