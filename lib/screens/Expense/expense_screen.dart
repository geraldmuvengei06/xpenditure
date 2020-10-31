import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xpenditure/helpers/database_helper.dart';
import 'package:xpenditure/models/expense_model.dart';

import 'add_expense_screen.dart';

class ExpenseScreen extends StatefulWidget {
  ExpenseScreen({Key key}) : super(key: key);

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  Future<List<Expense>> _expensesList;
  final DateFormat _dateFormat = new DateFormat('MMM dd, yyy');

  @override
  void initState() {
    super.initState();
    _updateExpensesList();
  }

  _updateExpensesList() {
    setState(() {
      _expensesList = DatabaseHelper.instance.getExpenses();
    });
  }

  Widget _buildItem(Expense expense) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(1, 1))
                ]),
            width: double.infinity,
            child: ListTile(
              dense: true,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    expense.amount.toString(),
                    style: TextStyle(
                        fontSize: 18.0,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    '${_dateFormat.format(expense.date)}',
                    style: TextStyle(
                        fontSize: 14.0,
                        decoration: TextDecoration.none,
                        color: Theme.of(context).accentColor),
                  ),
                ],
              ),
              subtitle: Text(
                expense.description,
                style:
                    TextStyle(fontSize: 12.0, decoration: TextDecoration.none),
              ),
              trailing: Checkbox(
                // mark a task as complete
                onChanged: null,
                activeColor: Theme.of(context).accentColor,
                value: true,
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddExpenseScreen(
                          expense: expense,
                          updateExpenseList: _updateExpensesList))),
            )),
      ],
    );
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
              "Expenses",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            Text("Track your expenses",
                style: TextStyle(color: Colors.grey, fontSize: 14.0)),
          ],
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.0),
              FutureBuilder(
                  future: _expensesList,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildItem(snapshot.data[index]);
                      },
                    );
                  }),
              SizedBox(
                height: 80.0,
              )
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add),
        elevation: 5.0,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddExpenseScreen(
                      updateExpenseList: _updateExpensesList,
                    ))),
      ),
    );
  }
}
