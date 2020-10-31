import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xpenditure/helpers/database_helper.dart';
//import 'package:xpenditure/helpers/database_helper.dart';
import 'package:xpenditure/models/earning_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddEarningScreen extends StatefulWidget {
  final Earning earning;
  final Function updateEaningList;

  AddEarningScreen({Key key, this.earning, this.updateEaningList})
      : super(key: key);

  @override
  _AddEarningScreenState createState() => _AddEarningScreenState();
}

class _AddEarningScreenState extends State<AddEarningScreen> {
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
    if (widget.earning != null) {
      _date = widget.earning.date;
      _description = widget.earning.description;
      _amount = widget.earning.amount.toString();
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

  _saveEarning() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        print("$_amount $_date $_description");

        Earning earning = Earning(
            amount: double.parse(_amount),
            description: _description,
            date: _date);

        if (widget.earning == null) {
          earning.status = 0;
          DatabaseHelper.instance.insertEarning(earning);
          Fluttertoast.showToast(msg: "Earning added successifully");
        } else {
          earning.id = widget.earning.id;
          earning.status = widget.earning.status;
          DatabaseHelper.instance.updateEarning(earning);
          Fluttertoast.showToast(msg: "Earning updated successifully");
        }
        _formKey.currentState.reset();

        widget.updateEaningList();
        Navigator.pop(context);
      }
    }
  }

  _deleteEarning() async {
    DatabaseHelper.instance.deleteEarning(widget.earning);
    Fluttertoast.showToast(msg: "Deleted successifully");
    widget.updateEaningList();
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
              widget.earning == null ? "Add Earning" : "Update Earning",
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
                  style: TextStyle(fontSize: 16.0),
                  keyboardType: TextInputType.number,
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
                  keyboardType: TextInputType.text,
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
                  widget.earning == null
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
                            onPressed: _saveEarning,
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
                                  onPressed: _saveEarning,
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
                                  onPressed: _deleteEarning,
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
