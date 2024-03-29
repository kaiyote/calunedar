import 'package:calunedar/calendar/attic_date.dart';
import 'package:calunedar/calendar/coligny_date.dart';
import 'package:calunedar/redux/models.dart';
import 'package:calunedar/redux/src/location_service.dart';
import 'package:dart_date/dart_date.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SetCalendarTypeAction {
  const SetCalendarTypeAction(this.calendarType);

  final CalendarType calendarType;
}

class SetMetonicAction {
  const SetMetonicAction(this.metonic);

  final bool metonic;
}

class Set24HourDisplayAction {
  const Set24HourDisplayAction(this.use24hr);

  final bool use24hr;
}

class SetGreekNameDisplayAction {
  const SetGreekNameDisplayAction(this.useGreekName);

  final bool useGreekName;
}

class SetDateAction {
  const SetDateAction(this.date);

  final DateTime date;
}

class SetShowFloatingScrollAction {
  const SetShowFloatingScrollAction(this.showScrollToEvents);

  final bool showScrollToEvents;
}

class SetPositionAction {
  const SetPositionAction(this.position);

  final Position? position;
}

SetDateAction changeToToday() {
  return SetDateAction(DateTime.now());
}

ThunkAction<AppState> changeMonth([bool forward = true]) {
  return (Store<AppState> store) {
    final currentDate = store.state.date;

    switch (store.state.settings.calendarType) {
      case CalendarType.gregorian:
        store.dispatch(
          SetDateAction(
            currentDate.addMonths(forward ? 1 : -1).startOfMonth,
          ),
        );
        break;
      case CalendarType.coligny:
        final colignyDate =
            ColignyDate.fromDateTime(currentDate, store.state.settings.metonic);
        final targetDate = forward
            ? colignyDate.lastDayOfMonth().addDays(1)
            : colignyDate.firstDayOfMonth().addDays(-1).firstDayOfMonth();
        store.dispatch(SetDateAction(targetDate.toDateTime()));
        break;
      case CalendarType.attic:
        final atticDate = AtticDate.fromDateTime(
            currentDate, store.state.position ?? defaultPosition);
        final targetDate = forward
            ? atticDate.lastDayOfMonth().addDays(1)
            : atticDate.firstDayOfMonth().addDays(-1).firstDayOfMonth();
        final diff = atticDate.differenceInDays(targetDate);
        final gregorianTarget =
            currentDate.addDays(forward ? diff : -diff, true);

        store.dispatch(SetDateAction(gregorianTarget));
        break;
    }
  };
}

void updatePosition(Store<AppState> store) async {
  // only bother with position if its null or older than a day
  if (store.state.position?.timestamp == null ||
      store.state.position!.timestamp! <= DateTime.now().addDays(-1, true)) {
    final position = await getPosition().catchError((_, __) => null);

    store.dispatch(SetPositionAction(position));
  }
}
