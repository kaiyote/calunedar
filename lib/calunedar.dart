import 'dart:math';

import 'package:calunedar/settings.dart';
import 'package:calunedar/widgets/app_bar.dart';
import 'package:calunedar/widgets/month.dart';
import 'package:calunedar/widgets/month_info.dart';
import 'package:calunedar/widgets/month_readout.dart';
import 'package:calunedar/widgets/settings_drawer.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Calunedar extends StatefulWidget {
  @override
  _CalunedarState createState() => _CalunedarState();
}

class _CalunedarState extends State<Calunedar> {
  var _date = Date.today;

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      final monthInfo = MonthInfo(date: _date);
      final media = MediaQuery.of(context);

      return Scaffold(
        drawer: SettingsDrawer(settings: settings),
        appBar: CalendarAppBar(
          date: _date,
          setDate: (DateTime newDate) {
            this.setState(() {
              _date = newDate;
            });
          },
        ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Month(date: _date, monthInfo: monthInfo),
                    Divider(
                      color: Colors.black,
                      thickness: 1.0,
                      height: 30.0,
                    ),
                    MonthReadout(monthInfo: monthInfo),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
