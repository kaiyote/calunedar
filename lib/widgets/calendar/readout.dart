import 'package:calunedar/redux/actions.dart';
import 'package:calunedar/redux/date_formatter.dart';
import 'package:calunedar/redux/models.dart';
import 'package:calunedar/redux/src/month_info.dart';
import 'package:calunedar/widgets/calendar/src/readout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:visibility_detector/visibility_detector.dart';

final watcherKey = GlobalKey();

class _ViewModel {
  const _ViewModel({
    required this.monthInfo,
    required this.formatter,
    required this.dispatch,
    required this.showScrollToEvents,
  });

  final MonthInfo monthInfo;
  final DateFormatter formatter;
  final dynamic Function(dynamic) dispatch;
  final bool showScrollToEvents;
}

class Readout extends StatelessWidget {
  const Readout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      builder: (context, state) => VisibilityDetector(
        key: watcherKey,
        onVisibilityChanged: (visibilityInfo) {
          if (state.showScrollToEvents !=
              (visibilityInfo.visibleFraction < 0.2)) {
            state.dispatch(
              SetShowFloatingScrollAction(visibilityInfo.visibleFraction < 0.2),
            );
          }
        },
        child: ReadoutImpl(
          monthInfo: state.monthInfo,
          formatDate: state.formatter.formatForReadout,
          formatEvent: state.formatter.formatEvent,
        ),
      ),
      converter: (store) => _ViewModel(
        monthInfo: monthInfoSelector(store.state),
        formatter: dateFormatterSelector(store.state),
        dispatch: store.dispatch,
        showScrollToEvents: store.state.showScrollToEvents,
      ),
    );
  }
}
