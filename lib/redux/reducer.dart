import 'package:calunedar/redux/actions.dart';
import 'package:calunedar/redux/models.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';

Settings changeMetonicReducer(Settings settings, SetMetonicAction action) =>
    settings.copyWith(metonic: action.metonic);

Settings changeCalendarTypeReducer(
        Settings settings, SetCalendarTypeAction action) =>
    settings.copyWith(calendarType: action.calendarType);

Settings change24hrDisplayReducer(
        Settings settings, Set24HourDisplayAction action) =>
    settings.copyWith(use24hr: action.use24hr);

Settings changeGreekNameDisplayReducer(
        Settings settings, SetGreekNameDisplayAction action) =>
    settings.copyWith(useGreekNames: action.useGreekName);

final settingsReducer = combineReducers<Settings>([
  TypedReducer<Settings, SetMetonicAction>(changeMetonicReducer),
  TypedReducer<Settings, SetCalendarTypeAction>(changeCalendarTypeReducer),
  TypedReducer<Settings, Set24HourDisplayAction>(change24hrDisplayReducer),
  TypedReducer<Settings, SetGreekNameDisplayAction>(
    changeGreekNameDisplayReducer,
  ),
]);

final dateReducer =
    TypedReducer<DateTime, SetDateAction>((_, action) => action.date);

final scrollToEventsReducer = TypedReducer<bool, SetShowFloatingScrollAction>(
    (_, action) => action.showScrollToEvents);

final positionReducer =
    TypedReducer<Position?, SetPositionAction>((_, action) => action.position);

AppState reducer(AppState state, action) => AppState(
      settings: settingsReducer(state.settings, action),
      date: dateReducer(state.date, action),
      showScrollToEvents:
          scrollToEventsReducer(state.showScrollToEvents, action),
      position: positionReducer(state.position, action),
    );
