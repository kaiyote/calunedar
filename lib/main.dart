import 'dart:convert';

import 'package:calunedar/extra_licenses.dart';
import 'package:calunedar/state/settings.dart';
import 'package:calunedar/calunedar.dart';
import 'package:calunedar/state/app_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(extraLicenses);
  final prefs = await SharedPreferences.getInstance();
  final license = await rootBundle.loadString('LICENSE');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Settings>(
          create: (_) {
            final settingsJson = prefs.getString(SETTINGS_KEY);
            return settingsJson != null
                ? Settings.fromJson(jsonDecode(settingsJson))
                : Settings();
          },
        ),
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(
            license.split("\n")[0],
          ),
        ),
      ],
      child: _Root(),
    ),
  );
}

class _Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calunedar',
      home: Calunedar(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
