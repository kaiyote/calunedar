import 'package:calunedar/app_bar.dart';
import 'package:calunedar/month.dart';
import 'package:calunedar/month_info.dart';
import 'package:calunedar/month_readout.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Calunedar',
      home: Calunedar(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.cyan,
          backgroundColor: Colors.white,
        ),
      ),
    ),
  );
}

class Calunedar extends StatefulWidget {
  @override
  _CalunedarState createState() => _CalunedarState();
}

class _CalunedarState extends State<Calunedar> {
  var _date = Date.today;

  @override
  Widget build(BuildContext context) {
    var monthInfo = MonthInfo(date: _date);

    return Scaffold(
      appBar: CalendarAppBar(
        date: _date,
        setDate: (DateTime newDate) {
          this.setState(() {
            _date = newDate;
          });
        },
      ),
      body: Container(
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
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      ),
    );
  }
}
