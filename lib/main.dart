import 'dart:convert';
import 'dart:math';

import 'package:calunedar/calunedar.dart';
import 'package:calunedar/widgets/app_bar.dart';
import 'package:calunedar/widgets/month.dart';
import 'package:calunedar/widgets/month_info.dart';
import 'package:calunedar/widgets/month_readout.dart';
import 'package:calunedar/settings.dart';
import 'package:calunedar/widgets/settings_drawer.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (_) {
        final settingsJson = prefs.getString(SETTINGS_KEY);
        return settingsJson != null
            ? Settings.fromJson(jsonDecode(settingsJson))
            : Settings();
      },
      child: _Root(),
    ),
  );
}

class _Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, child) => MaterialApp(
        title: 'Calunedar',
        home: Calunedar(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: settings.colorSwatch,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
