import 'package:calunedar/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
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

class _SettingsDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final calendar = context.select<Settings, CalendarType>((s) => s.calendar);
    final metonic = context.select<Settings, bool>((s) => s.metonic);

    final calendarList = <Widget>[
      ListTile(
        leading: const Text('Calendar: '),
        dense: true,
        visualDensity: VisualDensity.comfortable,
        title: DropdownButton<CalendarType>(
          value: calendar,
          onChanged: (CalendarType? newValue) {
            Provider.of<Settings>(context, listen: false).calendar =
                newValue ?? CalendarType.gregorian;
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

    if (calendar != CalendarType.gregorian) {
      calendarList.add(ListTile(
        title: Icon(!metonic ? Icons.check_circle_outline : Icons.check_circle),
        leading: const Text('Metonic: '),
        dense: true,
        onTap: () {
          Provider.of<Settings>(context, listen: false).metonic = !metonic;
        },
      ));
    }

    return Column(children: calendarList);
  }
}
