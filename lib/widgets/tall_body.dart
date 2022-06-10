import 'package:calunedar/redux/actions.dart';
import 'package:calunedar/redux/models.dart';
import 'package:calunedar/widgets/calendar/calendar.dart';
import 'package:calunedar/widgets/calendar/readout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';

class TallBody extends StatelessWidget {
  const TallBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Position?>(
      onInit: (store) => store.dispatch(updatePosition),
      converter: (store) => store.state.position ?? defaultPosition,
      builder: (context, position) {
        if (position != null) {
          return ListView.separated(
            padding: const EdgeInsets.all(15.0),
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) => Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1000 / (index + 1)),
                child: index == 0 ? const Calendar() : const Readout(),
              ),
            ),
            separatorBuilder: (BuildContext context, int index) => Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: const Divider(color: Colors.black),
              ),
            ),
          );
        } else {
          return const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
