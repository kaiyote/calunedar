import 'package:calunedar/state/app_state.dart';
import 'package:calunedar/state/date_formatter.dart';
import 'package:calunedar/state/settings.dart';
import 'package:calunedar/widgets/calendar/src/readout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

final watcherKey = GlobalKey();

class Readout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final monthInfo = context.watch<AppState>().monthInfo(context);
    final dateFormatter = context
        .select<Settings, DateFormatter>((s) => s.dateFormatter(context));

    return VisibilityDetector(
      key: watcherKey,
      onVisibilityChanged: (visibilityInfo) {
        Provider.of<AppState>(context, listen: false).showActionButton =
            (visibilityInfo.visibleFraction < 0.2);
      },
      child: ReadoutImpl(
        monthInfo: monthInfo,
        formatDate: dateFormatter.formatForReadout,
      ),
    );
  }
}
