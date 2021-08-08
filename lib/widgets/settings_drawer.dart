import 'package:calunedar/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Settings Menu'),
          ),
          ..._buildCalendar(
            context: context,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCalendar({required BuildContext context}) {
    final calendar = context.select<Settings, CalendarType>((s) => s.calendar);
    final metonic = context.select<Settings, bool>((s) => s.metonic);

    final calendarList = <Widget>[
      ListTile(
        leading: Text('Calendar: '),
        dense: true,
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

    return calendarList;
  }
}
