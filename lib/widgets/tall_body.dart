import 'package:calunedar/state/app_state.dart';
import 'package:calunedar/widgets/calendar/calendar.dart';
import 'package:calunedar/widgets/calendar/readout.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class TallBody extends StatelessWidget {
  const TallBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final positionFuture =
        context.select<AppState, Future<Position?>>((s) => s.location);

    return FutureBuilder<Position?>(
      future: positionFuture,
      builder: (BuildContext context, AsyncSnapshot<Position?> snapshot) {
        if (snapshot.hasData || snapshot.hasError) {
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
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          );
        }
      },
    );
  }
}
