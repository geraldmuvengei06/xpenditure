class Earning {
  int id;
  double amount;
  String description;
  DateTime date;
  int status;

  Earning({this.id, this.amount, this.description, this.date, this.status});

  Earning.withId(
      {this.id, this.amount, this.description, this.date, this.status});

  // convert data into map for storing
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id == null) {
      map['id'] = id;
    }
    map['amount'] = amount;
    map['description'] = description;
    map['date'] = date.toIso8601String();
    map['status'] = status;
    return map;
  }

  // convert map into list for dislay

  factory Earning.fromMap(Map<String, dynamic> map) {
    return Earning.withId(
        id: map['id'],
        amount: double.parse(map['amount']),
        description: map['description'],
        date: DateTime.parse(map['date']),
        status: map['status']);
  }

  // factory Earning.total(List<Map<String, dynamic>> earning) {
  //   return earning.length > 0 ? earning[0]['total'] : '0.0';
  // }
}
