import 'package:calunedar/app_state.dart';
import 'package:calunedar/widgets/calendar/calendar.dart';
import 'package:calunedar/widgets/calendar/readout.dart';
import 'package:calunedar/widgets/month_info_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TallBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final monthInfo = buildMonthInfo(state);

    final listItems = [
      Calendar(state: state, monthInfo: monthInfo),
      Readout(state: state, monthInfo: monthInfo),
    ];

    return ListView.separated(
      padding: EdgeInsets.all(15.0),
      itemCount: listItems.length,
      itemBuilder: (BuildContext context, int index) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1000 / (index + 1)),
          child: listItems[index],
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
