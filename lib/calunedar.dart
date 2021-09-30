import 'package:calunedar/redux/actions.dart';
import 'package:calunedar/redux/date_formatter.dart';
import 'package:calunedar/redux/models.dart';
import 'package:calunedar/widgets/calendar/readout.dart';
import 'package:calunedar/widgets/settings_drawer.dart';
import 'package:calunedar/widgets/tall_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class _ViewModel {
  const _ViewModel({required this.formatter, required this.date});

  final DateFormatter formatter;
  final DateTime date;
}

class Calunedar extends StatelessWidget {
  const Calunedar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SettingsDrawer(),
      appBar: AppBar(
        title: StoreConnector<AppState, _ViewModel>(
          converter: (store) => _ViewModel(
            date: store.state.date,
            formatter: dateFormatterSelector(store.state),
          ),
          builder: (context, state) => Text(
            state.formatter.formatForHeader(state.date),
          ),
        ),
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
      floatingActionButton: StoreConnector<AppState, bool>(
        converter: (store) => store.state.showScrollToEvents,
        builder: (context, showScrollToEvents) => Offstage(
          offstage: !showScrollToEvents,
          child: FloatingActionButton(
            child: const Icon(Icons.brightness_2_outlined),
            onPressed: () => Scrollable.ensureVisible(
              watcherKey.currentContext!,
              duration: const Duration(milliseconds: 250),
            ),
          ),
        ),
      ),
      bottomNavigationBar: StoreConnector<AppState, dynamic Function(dynamic)>(
        converter: (store) => store.dispatch,
        builder: (context, dispatch) => BottomNavigationBar(
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
            if (index == 1) {
              dispatch(changeToToday());
            } else {
              dispatch(changeMonth(index != 0));
            }
          },
        ),
      ),
    );
  }
}
