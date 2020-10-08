import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:xpence/models/Budget.dart';

class BudgetDatabaseHelper {
  static BudgetDatabaseHelper _budgetDatabaseHelper;
  static Database _database;

  String tableName = 'budget_table';
  String colId = 'id';
  String colAmount = 'amount';
  String colMonth = 'month';

  factory BudgetDatabaseHelper() {
    if (_budgetDatabaseHelper == null) {
      _budgetDatabaseHelper = BudgetDatabaseHelper._createInstance();
    }
    return _budgetDatabaseHelper;
  }

  BudgetDatabaseHelper._createInstance();

  get database async {
    if (_database == null) {
      _database = await initalizeDatabase();
    }
    return _database;
  }

  Future<Database> initalizeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'budget.db';

    var budgetDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return budgetDatabase;
  }

  _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colAmount INTEGER,$colMonth TEXT UNIQUE)');
  }

  //Fetch
  Future<List<Map<String, dynamic>>> getTransactionsList() async {
    Database db = await this.database;
    var result = await db.query(
      tableName,
      orderBy: '$colId ASC',
    );
    return result;
  }

  // Delete
  Future<int> deleteBudget(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $tableName WHERE $colId = $id');
    return result;
  }

  Future<int> turncateBudget() async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $tableName');
    return result;
  }

  Future<List<Map<String, dynamic>>> getCurrentMonthBudget(
      String currentMonth) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "SELECT * FROM $tableName WHERE $colMonth= ?", [currentMonth]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getCustomMonthBudget(
      String currentMonth) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "SELECT * FROM $tableName WHERE $colMonth= ?", [currentMonth]);
    return result;
  }

  // Insert
  Future<int> insertTransaction(Budget budget) async {
    Database db = await this.database;
    var result = await db.insert(tableName, budget.toJson());
    return result;
  }

  // Update
  Future<int> updateTransactionByMonth(Budget budget) async {
    Database db = await database;
    var result = await db.update(tableName, budget.toJson(),
        where: '$colId = ?', whereArgs: [budget.id]);
    return result;
  }
}
