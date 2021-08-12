import 'package:calunedar/state/app_state.dart';
import 'package:calunedar/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const _sourceUrl = "https://github.com/kaiyote/calunedar";

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final license = context.select<AppState, String>((s) => s.license);

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
                    DrawerHeader(
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
                          applicationLegalese:
                              'Copyright (c) 2021 Tim Huddle\n\n' + license,
                          aboutBoxChildren: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Text('Source'),
                                  onPressed: _launchUrl,
                                ),
                                TextButton(
                                  child: Text('License Text'),
                                  onPressed: () => _launchUrl(
                                    '$_sourceUrl/blob/main/LICENSE',
                                  ),
                                ),
                              ],
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

  void _launchUrl([String url = _sourceUrl]) async =>
      await canLaunch(url) ? launch(url) : throw 'Could not launch $url';
}

class _SettingsDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final calendar = context.select<Settings, CalendarType>((s) => s.calendar);
    final metonic = context.select<Settings, bool>((s) => s.metonic);

    final calendarList = <Widget>[
      ListTile(
        leading: Text('Calendar: '),
        dense: true,
        visualDensity: VisualDensity.comfortable,
        title: DropdownButton<CalendarType>(
          value: calendar,
          onChanged: (CalendarType? newValue) {
            Provider.of<Settings>(context, listen: false).calendar =
                newValue ?? CalendarType.GREGORIAN;
          },
          isDense: true,
          items: CalendarType.values
              .map(
                (e) => DropdownMenuItem(
                  child: Text(describeEnum(e)[0] +
                      describeEnum(e).substring(1).toLowerCase()),
                  value: e,
                ),
              )
              .toList(),
        ),
      ),
    ];

    if (calendar != CalendarType.GREGORIAN) {
      calendarList.add(ListTile(
        title: Icon(!metonic ? Icons.check_circle_outline : Icons.check_circle),
        leading: Text('Metonic: '),
        dense: true,
        onTap: () {
          Provider.of<Settings>(context, listen: false).metonic = !metonic;
        },
      ));
    }

    return Column(children: calendarList);
  }
}
