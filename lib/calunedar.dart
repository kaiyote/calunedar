import 'dart:math';

import 'package:calunedar/calendar/coligny_calendar.dart';
import 'package:calunedar/settings.dart';
import 'package:calunedar/widgets/app_bar.dart';
import 'package:calunedar/widgets/gregorian/month.dart';
import 'package:calunedar/widgets/coligny/month.dart' as C;
import 'package:calunedar/widgets/month_info/coligny.dart';
import 'package:calunedar/widgets/month_info/month_info.dart';
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
    final media = MediaQuery.of(context);
    final calendar = context.select<Settings, CalendarType>((s) => s.calendar);
    final metonic = context.select<Settings, bool>((s) => s.metonic);

    MonthInfo monthInfo;
    switch (calendar) {
      case CalendarType.GREGORIAN:
        monthInfo = MonthInfo(date: _date);
        break;
      case CalendarType.COLIGNY:
        monthInfo = ColignyMonthInfo(date: _date, metonic: metonic);
        break;
    }

    return Scaffold(
      drawer: SettingsDrawer(),
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
                  _calendar(
                    monthInfo: monthInfo,
                    calendar: calendar,
                    metonic: metonic,
                  ),
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
  }

  Widget _calendar({
    @required MonthInfo monthInfo,
    @required CalendarType calendar,
    @required bool metonic,
  }) {
    switch (calendar) {
      case CalendarType.GREGORIAN:
        return GregorianMonth(date: _date, monthInfo: monthInfo);
      case CalendarType.COLIGNY:
        return C.ColignyMonth(
            date: ColignyCalendar.fromDateTime(_date, metonic),
            monthInfo: monthInfo);
    }
    return null;
  }
}
