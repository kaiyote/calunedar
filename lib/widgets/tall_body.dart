import 'package:calunedar/widgets/calendar/calendar.dart';
import 'package:calunedar/widgets/calendar/readout.dart';
import 'package:flutter/material.dart';

class TallBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(15.0),
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1000 / (index + 1)),
          child: index == 0 ? Calendar() : Readout(),
        ),
      ),
      separatorBuilder: (BuildContext context, int index) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1000),
          child: Divider(color: Colors.black),
        ),
      ),
    );
  }
}
