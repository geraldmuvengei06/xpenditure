import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xpenditure/models/earning_model.dart';
import 'package:xpenditure/models/expense_model.dart';

class DatabaseHelper {
  // db will have a single instance throughout the application
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  // DatabaseHelper();

  DatabaseHelper._instance();

  // create expenses table
  String expensesTable = 'expenses_table';
  String earningsTable = 'earnings_table';
  String colId = 'id';
  String colAmount = 'amount';
  String colDate = 'date';
  String colDescription = 'description';
  String colStatus = 'status';

  // getter function for the db
  Future<Database> get db async {
    // if no db exists init or create it
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  // create db
  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'xpenditure.db';
    final expenditureDb =
        await openDatabase(path, version: 1, onCreate: _createTables);

    // lots of stuff in async mode (create tables)

    return expenditureDb;
  }

  void _createTables(Database db, int version) async {
    Batch batch = db.batch();
    try {
      batch.execute(
          'CREATE TABLE $expensesTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colAmount TEXT, $colDate TEXT, $colDescription TEXT,  $colStatus INTEGER)');
    } catch (e) {}

    try {
      batch.execute(
          'CREATE TABLE $earningsTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colAmount TEXT, $colDate TEXT, $colDescription TEXT, $colStatus INTEGER)');
    } catch (e) {}
    await batch.commit();
  }

  ///////////////////////////////////////////////////////
  /// Earning
  /// ///////////////////////////////////////////////////

  // get earnings
  Future<List<Map<String, dynamic>>> getEarningsMap() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(earningsTable);
    return result;
  }

  // convert earnigs from map to list

  Future<List<Earning>> getEarnings() async {
    final List<Map<String, dynamic>> earningsMap = await getEarningsMap();
    final List<Earning> earningList = [];

    earningsMap.forEach((earningMap) {
      earningList.add(Earning.fromMap(earningMap));
      earningList
          .sort((eaningA, eaningB) => eaningB.date.compareTo(eaningA.date));
    });
    return earningList;
  }

  Future<List> getEarningsTotal() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> earningsMap =
        await db.rawQuery('select SUM(amount) as total from $earningsTable');
    // return Earning.total(earningsMap.toList()).toString();
    return earningsMap.toList();
  }

  // insert eaning

  Future<int> insertEarning(Earning earning) async {
    Database db = await this.db;
    final int result = await db.insert(earningsTable, earning.toMap());
    return result;
  }

  // update earning

  Future<int> updateEarning(Earning earning) async {
    Database db = await this.db;
    final int result = await db.update(earningsTable, earning.toMap(),
        where: "$colId = ?", whereArgs: [earning.id]);
    return result;
  }

  // delete eening

  Future<int> deleteEarning(Earning earning) async {
    Database db = await this.db;
    final int result = await db
        .delete(earningsTable, where: "$colId = ?", whereArgs: [earning.id]);
    return result;
  }

  ///////////////////////////////////////////////////////
  ///  End of Earning
  /// ///////////////////////////////////////////////////
  ///
  ///

  ///////////////////////////////////////////////////////
  ///  Expenses
  /// ///////////////////////////////////////////////////

  // get expenses

  Future<List<Map<String, dynamic>>> getExpensesMap() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(expensesTable);
    return result;
  }

  // convert expenses map to list

  Future<List<Expense>> getExpenses() async {
    final List<Map<String, dynamic>> expensesMap = await getExpensesMap();
    final List<Expense> expensesList = [];

    expensesMap.forEach((expenseMap) {
      expensesList.add(Expense.fromMap(expenseMap));
      expensesList
          .sort((expenseA, expenseB) => expenseB.date.compareTo(expenseA.date));
    });
    return expensesList;
  }

  // expenses total

  Future<List> getExpensesTotal() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> expensesMap =
        await db.rawQuery('SELECT SUM(amount) as total from $expensesTable');
    return expensesMap.toList();
    // return Expense.total(expensesMap.toList()).toString();
  }

  // insert expense
  Future<int> insertExpense(Expense expense) async {
    Database db = await this.db;
    final int result = await db.insert(expensesTable, expense.toMap());
    return result;
  }

  // update expense
  Future<int> updateExpense(Expense expense) async {
    Database db = await this.db;
    final int result = await db.update(expensesTable, expense.toMap(),
        where: '$colId = ?', whereArgs: [expense.id]);

    return result;
  }

  // delete expense
  Future<int> deleteExpense(Expense expense) async {
    Database db = await this.db;
    final int result = await db
        .delete(expensesTable, where: '$colId = ?', whereArgs: [expense.id]);
    return result;
  }

  ///////////////////////////////////////////////////////
  ///  End of Expenses
  /// ///////////////////////////////////////////////////
}
