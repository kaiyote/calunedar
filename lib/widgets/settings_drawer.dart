import 'package:calunedar/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:o_color_picker/o_color_picker.dart';
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
          _buildThemeColor(
            context: context,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCalendar({@required BuildContext context}) {
    final calendar = context.select<Settings, CalendarType>((s) => s.calendar);
    final metonic = context.select<Settings, bool>((s) => s.metonic);

    final calendarList = <Widget>[
      ListTile(
        leading: Text('Calendar: '),
        title: DropdownButton<CalendarType>(
          value: calendar,
          onChanged: (CalendarType newValue) {
            Provider.of<Settings>(context, listen: false).calendar = newValue;
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
          Provider.of<Settings>(context, listen: false).metonic = !metonic;
        },
      ));
    }

    return calendarList;
  }

  Widget _buildThemeColor({BuildContext context}) {
    final primaryColor = context.select<Settings, Color>((s) => s.primaryColor);

    return ListTile(
      leading: Text('Primary Theme Color: '),
      title: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
            (_) => primaryColor,
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
                selectedColor: primaryColor,
                colors: primaryColorsPalette,
                onColorChange: (color) {
                  Provider.of<Settings>(context, listen: false).primaryColor =
                      color;
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
