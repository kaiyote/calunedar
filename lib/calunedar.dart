import 'package:calunedar/widgets/app_bar.dart';
import 'package:calunedar/widgets/settings_drawer.dart';
import 'package:calunedar/widgets/tall_body.dart';
import 'package:flutter/material.dart';

class Calunedar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SettingsDrawer(),
      appBar: CalendarAppBar(),
      body: TallBody(),
    );
  }
}
