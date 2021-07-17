import 'package:calunedar/app_state.dart';
import 'package:calunedar/widgets/app_bar.dart';
import 'package:calunedar/widgets/calendar/readout.dart';
import 'package:calunedar/widgets/settings_drawer.dart';
import 'package:calunedar/widgets/tall_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Calunedar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final showActionButton =
        context.select<AppState, bool>((s) => s.showActionButton);

    return Scaffold(
      drawer: SettingsDrawer(),
      appBar: CalendarAppBar(),
      body: TallBody(),
      floatingActionButton: Offstage(
        offstage: !showActionButton,
        child: FloatingActionButton(
          child: const Icon(Icons.brightness_2_outlined),
          onPressed: () => Scrollable.ensureVisible(
            watcherKey.currentContext,
            duration: const Duration(milliseconds: 250),
          ),
        ),
      ),
    );
  }
}
