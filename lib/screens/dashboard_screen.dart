import 'package:flutter/material.dart';
import 'package:xpenditure/screens/Earning/earning_screen.dart';
import 'package:xpenditure/screens/Expense/expense_screen.dart';
import 'package:xpenditure/screens/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String title;
  DashboardScreen({this.title});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    AnimatedSwitcher(duration: const Duration(seconds: 1), child: HomeScreen()),
    EarningScreen(),
    ExpenseScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      // appBar: AppBar(
      //     shadowColor: Colors.white10,
      //     backgroundColor: Colors.white,
      //     title: Row(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: <Widget>[
      //         Text(
      //           widget.title,
      //           style: TextStyle(
      //               fontSize: 30.0, color: Theme.of(context).primaryColor),
      //         )
      //       ],
      //     )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        iconSize: 30.0,
        selectedFontSize: 15.0,
        selectedItemColor: Theme.of(context).primaryColor,
        selectedIconTheme: IconThemeData(size: 34.0),
        onTap: (value) {
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              backgroundColor: Colors.blueGrey,
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              backgroundColor: Colors.blueGrey,
              label: 'Earnings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.money_off),
              backgroundColor: Colors.blueGrey,
              label: 'Expenses')
        ],
      ),
    );
  }
}
