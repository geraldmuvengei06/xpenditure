import 'package:flutter/material.dart';
import 'package:xpenditure/screens/dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final String title = 'Xpenduture';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.pink,
          primaryColorDark: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DashboardScreen(title: title));
  }
}
