import 'package:calunedar/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  SettingsDrawer({this.settings});

  final Settings settings;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Settings Menu'),
          ),
          ListTile(
            leading: Icon(!settings.metonic
                ? Icons.check_circle_outline
                : Icons.check_circle),
            title: Text('Metonic'),
            onTap: () => {settings.metonic = !settings.metonic},
          ),
        ],
      ),
    );
  }
}
