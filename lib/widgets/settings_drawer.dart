import 'package:calunedar/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  List<Widget> _buildCalendar({@required BuildContext context}) {
    final calendar = context.select<AppState, CalendarType>((s) => s.calendar);
    final metonic = context.select<AppState, bool>((s) => s.metonic);

    final calendarList = <Widget>[
      ListTile(
        leading: Text('Calendar: '),
        title: DropdownButton<CalendarType>(
          value: calendar,
          onChanged: (CalendarType newValue) {
            Provider.of<AppState>(context, listen: false).calendar = newValue;
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
        onTap: () {
          Provider.of<AppState>(context, listen: false).metonic = !metonic;
        },
      ));
    }

    return calendarList;
  }
}
