import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xpenditure/helpers/database_helper.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _totalEarnings, _totalExpenses, _totalBal;
  List earnings, expenses;

  @override
  void initState() {
    super.initState();
    _getEarningTotal();
    _getExpensesTotal();
  }

  void _getEarningTotal() async {
    earnings = await DatabaseHelper.instance.getEarningsTotal();

    print('baaaaal');
    setState(() => _totalEarnings = earnings[0]['total']);
  }

  void _getExpensesTotal() async {
    expenses = await DatabaseHelper.instance.getExpensesTotal();
    setState(() => _totalExpenses = expenses[0]['total']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.white24,
          backgroundColor: Colors.white,
          toolbarHeight: 80.0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Dashboard",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              Text("Track your earnings and expenses",
                  style: TextStyle(color: Colors.grey, fontSize: 14.0)),
            ],
          ),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: SafeArea(
                // minimum: EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 18.0),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          height: 80.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.4)
                                  ]),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 4,
                                    blurRadius: 10,
                                    offset: Offset(2, 2))
                              ]),
                          child: ListTile(
                            title: Text(
                              "Earnings",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            subtitle: Text(
                              _totalEarnings != null
                                  ? _totalEarnings.toString()
                                  : '0.0',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.94),
                                  fontSize: 14.0),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.monetization_on),
                              color: Colors.white,
                              onPressed: () {},
                            ),
                          ),
                        ),
                        SizedBox(height: 18.0),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          height: 80.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Theme.of(context).accentColor,
                                    Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.4)
                                  ]),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 4,
                                    blurRadius: 10,
                                    offset: Offset(2, 2))
                              ]),
                          child: ListTile(
                            title: Text(
                              "Expenses",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            subtitle: Text(
                              _totalExpenses != null
                                  ? _totalExpenses.toString()
                                  : '0.0',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.94),
                                  fontSize: 14.0),
                            ),
                            trailing: Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.pinkAccent,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.money_sharp),
                                color: Colors.white,
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          height: 80.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Theme.of(context).primaryColorDark,
                                    Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.4)
                                  ]),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 4,
                                    blurRadius: 10,
                                    offset: Offset(2, 2))
                              ]),
                          child: ListTile(
                            title: Text(
                              "Balance",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            subtitle: Text(
                              _totalBal != null ? _totalBal.toString() : '0.0',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.94),
                                  fontSize: 14.0),
                            ),
                            trailing: Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.greenAccent,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.money_sharp),
                                color: Colors.white,
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 0, bottom: 20.0),
                          height: 300.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 4,
                                    blurRadius: 10,
                                    offset: Offset(2, 2))
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  'Summary',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                subtitle: Text('Expenditure summary'),
                                trailing: Text(
                                  'Oct, 2020',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ],
                    )))));
  }
}
