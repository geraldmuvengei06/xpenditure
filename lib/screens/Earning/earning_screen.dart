import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xpenditure/helpers/database_helper.dart';
import 'package:xpenditure/models/earning_model.dart';
import 'package:xpenditure/screens/Earning/add_earning_screen.dart';

class EarningScreen extends StatefulWidget {
  EarningScreen({Key key}) : super(key: key);

  @override
  _EarningScreenState createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  Future<List<Earning>> _eaningsList;
  final DateFormat _dateFormat = new DateFormat('MMM dd, yyy');

  @override
  void initState() {
    super.initState();
    _updateEarnings();
  }

  _updateEarnings() {
    setState(() {
      _eaningsList = DatabaseHelper.instance.getEarnings();
    });
  }

  Widget _buildItem(Earning earning) {
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
                    earning.amount.toString(),
                    style: TextStyle(
                        fontSize: 18.0,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    '${_dateFormat.format(earning.date)}',
                    style: TextStyle(
                        fontSize: 14.0,
                        decoration: TextDecoration.none,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              subtitle: Text(
                earning.description,
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
                      builder: (_) => AddEarningScreen(
                          earning: earning,
                          updateEaningList: _updateEarnings))),
              onLongPress: () {},
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
              "Earnings",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            Text("Track your earnings",
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
                  future: _eaningsList,
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
                        itemBuilder: (context, index) {
                          return _buildItem(snapshot.data[index]);
                        });
                  }),
              SizedBox(height: 80.0),
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        elevation: 5.0,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    AddEarningScreen(updateEaningList: _updateEarnings))),
      ),
    );
  }
}
