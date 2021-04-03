import 'package:calunedar/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/month.dart';
import 'src/month_info.dart';
import 'src/readout.dart';

class ColignyDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final date = context.select<AppState, DateTime>((state) => state.date);
    final metonic = context.select<AppState, bool>((state) => state.metonic);
    final monthInfo = MonthInfo(date: date, metonic: metonic);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Month(monthInfo: monthInfo, date: date, metonic: metonic),
        Divider(color: Colors.black, thickness: 1.0, height: 30.0),
        Readout(monthInfo: monthInfo),
      ],
    );
  }
}
