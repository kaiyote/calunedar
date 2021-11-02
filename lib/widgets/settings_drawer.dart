import 'package:calunedar/redux/actions.dart';
import 'package:calunedar/redux/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';

const _sourceUrl = "https://github.com/kaiyote/calunedar";

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: constraints.copyWith(
              minHeight: constraints.maxHeight,
              maxHeight: double.infinity,
            ),
            child: IntrinsicHeight(
              child: SafeArea(
                child: Column(
                  children: [
                    const DrawerHeader(
                      child: Center(
                        child: Text(
                          'Settings',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                    ),
                    _SettingsDisplay(),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AboutListTile(
                          applicationName: 'Calunedar',
                          applicationLegalese: 'Copyright (c) 2021 Tim Huddle',
                          aboutBoxChildren: [
                            TextButton(
                              child: const Text('Source'),
                              onPressed: _launchUrl,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _launchUrl() async => await canLaunch(_sourceUrl)
      ? launch(_sourceUrl)
      : throw 'Could not launch $_sourceUrl';
}

class _ViewModel {
  const _ViewModel({
    required this.calendarType,
    required this.metonic,
    required this.use24hr,
    required this.useGreekNames,
    required this.dispatch,
  });

  final CalendarType calendarType;
  final bool metonic;
  final bool use24hr;
  final bool useGreekNames;
  final dynamic Function(dynamic) dispatch;
}

class _SettingsDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        calendarType: store.state.settings.calendarType,
        metonic: store.state.settings.metonic,
        use24hr: store.state.settings.use24hr,
        useGreekNames: store.state.settings.useGreekNames,
        dispatch: store.dispatch,
      ),
      builder: (context, state) {
        final calendarList = <Widget>[
          ListTile(
            leading: const Text('Use 24 Hour Time Display: '),
            dense: true,
            visualDensity: VisualDensity.comfortable,
            title: Icon(!state.use24hr
                ? Icons.check_circle_outline
                : Icons.check_circle),
            onTap: () {
              state.dispatch(Set24HourDisplayAction(!state.use24hr));
            },
          ),
          ListTile(
            leading: const Text('Calendar: '),
            dense: true,
            visualDensity: VisualDensity.comfortable,
            title: DropdownButton<CalendarType>(
              value: state.calendarType,
              onChanged: (CalendarType? newValue) {
                state.dispatch(
                    SetCalendarTypeAction(newValue ?? CalendarType.gregorian));
              },
              isDense: true,
              items: CalendarType.values
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(
                        describeEnum(e)[0].toUpperCase() +
                            describeEnum(e).substring(1),
                      ),
                      value: e,
                    ),
                  )
                  .toList(),
            ),
          ),
        ];

        if (state.calendarType == CalendarType.coligny) {
          calendarList.add(
            ListTile(
              title: Icon(!state.metonic
                  ? Icons.check_circle_outline
                  : Icons.check_circle),
              leading: const Text('Metonic: '),
              dense: true,
              onTap: () {
                state.dispatch(SetMetonicAction(!state.metonic));
              },
            ),
          );
        }

        if (state.calendarType == CalendarType.attic) {
          calendarList.add(
            ListTile(
              title: Icon(!state.metonic
                  ? Icons.check_circle_outline
                  : Icons.check_circle),
              leading: const Text('Use Greek Names: '),
              dense: true,
              onTap: () {
                state.dispatch(SetGreekNameDisplayAction(!state.useGreekNames));
              },
            ),
          );
        }

        return Column(children: calendarList);
      },
    );
  }
}
