import 'package:calunedar/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:o_color_picker/o_color_picker.dart';
import 'package:provider/provider.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, children) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Settings Menu'),
            ),
            ..._buildCalendar(
              settings: settings,
            ),
            _buildThemeColor(
              settings: settings,
              context: context,
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildCalendar({@required Settings settings}) {
    final calendarList = <Widget>[
      ListTile(
        leading: Text('Calendar: '),
        title: DropdownButton<CalendarType>(
          value: settings.calendar,
          onChanged: (CalendarType newValue) {
            settings.calendar = newValue;
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

    if (settings.calendar != CalendarType.GREGORIAN) {
      calendarList.add(ListTile(
        title: Icon(!settings.metonic
            ? Icons.check_circle_outline
            : Icons.check_circle),
        leading: Text('Metonic: '),
        onTap: () => {settings.metonic = !settings.metonic},
      ));
    }

    return calendarList;
  }

  Widget _buildThemeColor({Settings settings, BuildContext context}) {
    return ListTile(
      leading: Text('Primary Theme Color: '),
      title: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => settings.primaryColor,
          ),
        ),
        child: Container(),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => Dialog(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: OColorPicker(
                boxBorder: OColorBoxBorder(
                  color: Colors.black,
                  radius: 5.0,
                ),
                selectedColor: settings.primaryColor,
                colors: primaryColorsPalette,
                onColorChange: (color) {
                  settings.primaryColor = color;
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
