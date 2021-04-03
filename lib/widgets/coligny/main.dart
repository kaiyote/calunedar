import 'package:calunedar/app_state.dart';
import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/month.dart';
import 'src/month_info.dart';
import 'src/readout.dart';

class ColignyDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final date =
        context.select<AppState, ColignyCalendar>((state) => state.colignyDate);
    final monthInfo = MonthInfo(date: date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Month(monthInfo: monthInfo, date: date),
        Divider(color: Colors.black, thickness: 1.0, height: 30.0),
        Readout(monthInfo: monthInfo),
      ],
    );
  }
}
