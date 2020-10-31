import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:xpenditure/helpers/database_helper.dart';
import 'package:xpenditure/models/expense_model.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense expense;
  final Function updateExpenseList;
  AddExpenseScreen({this.expense, this.updateExpenseList, key})
      : super(key: key);

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = new TextEditingController();
  final DateFormat _dateFormat = new DateFormat('MMM dd, yyy');
  DateTime _date = new DateTime.now();
  String _amount;
  String _description;

  @override
  void initState() {
    super.initState();

    _dateController.text = _dateFormat.format(_date);
    if (widget.expense != null) {
      _date = widget.expense.date;
      _description = widget.expense.description;
      _amount = widget.expense.amount.toString();
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2010),
        lastDate: DateTime(2100));

    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
    }

    _dateController.text = _dateFormat.format(date);
  }

  _saveExpense() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        print("$_amount $_date $_description");

        Expense expense = Expense(
            amount: double.parse(_amount),
            description: _description,
            date: _date);

        if (widget.expense == null) {
          expense.status = 0;
          DatabaseHelper.instance.insertExpense(expense);
          Fluttertoast.showToast(msg: "Expense added successifully");
        } else {
          expense.status = widget.expense.status;
          expense.id = widget.expense.id;
          DatabaseHelper.instance.updateExpense(expense);
          Fluttertoast.showToast(msg: "Expense updated successifully");
        }

        _formKey.currentState.reset();
        widget.updateExpenseList();
        Navigator.pop(context);
      }
    }
  }

  _deleteExpense() {
    DatabaseHelper.instance.deleteExpense(widget.expense);
    Fluttertoast.showToast(msg: "Deleted successifully");
    widget.updateExpenseList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        shadowColor: Colors.white10,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, size: 30.0, color: Colors.black),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.expense == null ? "Add Expense" : "Update Expense",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(fontSize: 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  validator: (value) =>
                      value.trim().isEmpty ? "Please enter amount" : null,
                  onSaved: (value) => {
                    setState(() => {_amount = value})
                  },
                  initialValue: _amount,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: TextFormField(
                  maxLines: 4,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(fontSize: 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  validator: (value) =>
                      value.trim().isEmpty ? "Please enter description" : null,
                  onSaved: (value) => {
                    setState(() => {_description = value})
                  },
                  initialValue: _description,
                ),
              ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: TextFormField(
                    readOnly: true,
                    style: TextStyle(fontSize: 16.0),
                    decoration: InputDecoration(
                        labelText: 'Date',
                        labelStyle: TextStyle(fontSize: 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    onTap: _handleDatePicker,
                    controller: _dateController,
                  )),
              Row(
                children: [
                  widget.expense == null
                      ? Container(
                          margin: EdgeInsets.only(
                              left: 20.0, right: 4.0, top: 10.0, bottom: 10.0),
                          height: 50.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: FlatButton(
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                            onPressed: _saveExpense,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20.0,
                                    right: 4.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                height: 50.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: FlatButton(
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                  onPressed: _saveExpense,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 4.0,
                                    right: 4.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                height: 50.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: FlatButton(
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                  onPressed: _deleteExpense,
                                ),
                              ),
                            ]),
                  SizedBox.shrink()
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
