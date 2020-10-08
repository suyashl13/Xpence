import 'dart:io';
import 'package:xpence/models/Transaction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String tableName = 'transaction_table';
  String colId = 'id';
  String colCategory = 'category';
  String colTitle = 'title';
  String colDate = 'date';
  String colAmount = 'amount';
  String colMonth = 'month';

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createinstance();
    }
    return _databaseHelper;
  }

  DatabaseHelper._createinstance();

  get database async {
    if (_database == null) {
      _database = await initalizeDatabase();
    }
    return _database;
  }

  Future<Database> initalizeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'transactions.db';

    var transactionDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return transactionDatabase;
  }

  _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colCategory TEXT,$colTitle TEXT,$colDate TEXT,$colAmount INTEGER,$colMonth TEXT)');
  }

  // Fetch
  Future<List<Map<String, dynamic>>> getTransactionsList() async {
    Database db = await this.database;
    var result = await db.query(
      tableName,
      orderBy: '$colId ASC',
    );
    return result;
  }

  // Insert
  Future<int> insertTransaction(DbTransaction transaction) async {
    Database db = await this.database;
    var result = await db.insert(tableName, transaction.toMap());
    return result;
  }

  // Delete
  Future<int> deleteTransaction(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $tableName WHERE $colId = $id');
    return result;
  }

  Future<int> turnCateTransactions() async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $tableName');
    return result;
  }

  // Get number of DbTransaction objects from database.
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $tableName');
    int result = Sqflite.firstIntValue(x);
    return result;
  }


  // Update
  Future<int> updateTransaction(DbTransaction transaction) async {
    Database db = await database;
    var result = await db.update(tableName, transaction.toMap(),
        where: '$colId = ?', whereArgs: [transaction.id]);
    return result;
  }

  // UNUSED Methods.
  // Future<List<DbTransaction>> getTransactionArrayList() async {
  //   var dbTransactionMapList =
  //       await getTransactionsList(); // Get 'Map List' from database
  //   int count = dbTransactionMapList
  //       .length; // Count the number of map entries in db table

  //   List<DbTransaction> dbTransactionList = List<DbTransaction>();
  //   // For loop to create a 'Note List' from a 'Map List'
  //   for (int i = 0; i < count; i++) {
  //     dbTransactionList.add(DbTransaction.fromMap(dbTransactionMapList[i]));
  //   }
  //   return dbTransactionList;
  // }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////

  // Application methods
  // HomePage
  Future<List<Map<String, dynamic>>> getTransactionsByMonth(
      String monthYear) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "SELECT * FROM $tableName WHERE $colMonth= ? ORDER BY $colId ASC",
        [monthYear]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getTodaysTransactions(
      String dateToday) async {
    Database db = await this.database;
    var result = await db
        .rawQuery("SELECT * FROM $tableName WHERE $colDate= ?", [dateToday]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getCategoryAndAmountOfMonth(
      String monthYear) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "SELECT $colCategory,$colAmount FROM $tableName WHERE $colMonth= ?",
        [monthYear]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getMonths() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT DISTINCT $colMonth from $tableName");
    return result;
  }
}
