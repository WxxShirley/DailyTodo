import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:todo/widget/calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(child: 
      MaterialApp(
        title: 'TODO',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:  CalendarPage(),
        debugShowCheckedModeBanner: false,
    ),
    );
  }
}

