import 'dart:math';

import 'package:calunedar/app_state.dart';
import 'package:calunedar/widgets/app_bar.dart';
import 'package:calunedar/widgets/coligny/main.dart';
import 'package:calunedar/widgets/gregorian/main.dart';
import 'package:calunedar/widgets/settings_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Calunedar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      drawer: SettingsDrawer(),
      appBar: CalendarAppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 15.0,
            ),
            width: min(media.size.width, 1024.0),
            child: SingleChildScrollView(
              child: _calendar(
                calendar: context.select<AppState, CalendarType>(
                  (s) => s.calendar,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _calendar({CalendarType calendar}) {
    switch (calendar) {
      case CalendarType.GREGORIAN:
        return GregorianDisplay();
      case CalendarType.COLIGNY:
        return ColignyDisplay();
    }
    return null;
  }
}
