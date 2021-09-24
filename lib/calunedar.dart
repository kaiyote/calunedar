import 'package:calunedar/calendar/coligny_date.dart';
import 'package:calunedar/state/app_state.dart';
import 'package:calunedar/state/date_formatter.dart';
import 'package:calunedar/state/settings.dart';
import 'package:calunedar/widgets/calendar/readout.dart';
import 'package:calunedar/widgets/settings_drawer.dart';
import 'package:calunedar/widgets/tall_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dart_date/dart_date.dart';

class Calunedar extends StatelessWidget {
  const Calunedar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = context
        .select<Settings, DateFormatter>((s) => s.dateFormatter(context));
    final date = context.select<AppState, DateTime>((s) => s.date);
    final showActionButton =
        context.select<AppState, bool>((s) => s.showActionButton);

    return Scaffold(
      drawer: const SettingsDrawer(),
      appBar: AppBar(
        title: Text(formatter.formatForHeader(date)),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Open Settings Menu',
            );
          },
        ),
      ),
      body: const TallBody(),
      floatingActionButton: Offstage(
        offstage: !showActionButton,
        child: FloatingActionButton(
          child: const Icon(Icons.brightness_2_outlined),
          onPressed: () => Scrollable.ensureVisible(
            watcherKey.currentContext!,
            duration: const Duration(milliseconds: 250),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Previous Month',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_circle_down),
            label: 'Current Month',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: 'Next Month',
          ),
        ],
        currentIndex: 1,
        onTap: (index) {
          final settings = Provider.of<Settings>(context, listen: false);
          if (index == 1) {
            Provider.of<AppState>(context, listen: false).date = DateTime.now();
          } else {
            Provider.of<AppState>(context, listen: false).date =
                _addMonths(date, index - 1, settings);
          }
        },
      ),
    );
  }

  DateTime _addMonths(DateTime date, int months, Settings settings) {
    switch (settings.calendar) {
      case CalendarType.gregorian:
        return date.addMonths(months);
      case CalendarType.coligny:
        var coligny = ColignyDate.fromDateTime(date, settings.metonic);
        return date.addDays(coligny.monthLength * months.sign);
    }
  }
}
