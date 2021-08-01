import 'package:calunedar/app_state.dart';
import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:calunedar/widgets/calendar/src/month_info.dart';
import 'package:calunedar/widgets/calendar/src/readout.dart' as S;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

final watcherKey = GlobalKey();

class Readout extends StatelessWidget {
  Readout({
    required this.state,
    required this.monthInfo,
  });

  final AppState state;
  final MonthInfo monthInfo;

  @override
  Widget build(BuildContext context) {
    final display = () {
      switch (state.calendar) {
        case CalendarType.COLIGNY:
          return _coligny(context);
        default:
          return _gregorian(context);
      }
    }();

    return VisibilityDetector(
      key: watcherKey,
      onVisibilityChanged: (visibilityInfo) {
        Provider.of<AppState>(context, listen: false).showActionButton =
            (visibilityInfo.visibleFraction < 0.2);
      },
      child: display,
    );
  }

  Widget _gregorian(BuildContext context) {
    var dateFormatter = DateFormat.MMMMd().addPattern('\'at\'');
    dateFormatter = MediaQuery.of(context).alwaysUse24HourFormat
        ? dateFormatter.add_Hm()
        : dateFormatter.add_jm();

    return S.Readout(
      monthInfo: monthInfo,
      formatDate: dateFormatter.format,
    );
  }

  Widget _coligny(BuildContext context) {
    final dateFormatter = MediaQuery.of(context).alwaysUse24HourFormat
        ? DateFormat.Hm()
        : DateFormat.jm();

    return S.Readout(
      monthInfo: monthInfo,
      formatDate: (dt) {
        var colignyDate = ColignyCalendar.fromDateTime(dt, state.metonic);
        return '${colignyDate.monthName} ${colignyDate.day} at ${dateFormatter.format(dt.toLocal())}';
      },
    );
  }
}
