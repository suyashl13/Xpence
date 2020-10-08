import 'package:xpence/db/budget_database_helper.dart';
import 'package:xpence/db/database_helper.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class HelperMethods {
  DatabaseHelper db;

  getTodaysExpenditureCost() async {
    var a = await DatabaseHelper()
        .getTodaysTransactions(DateFormat.yMMMd().format(DateTime.now()));
    int cost = 0;
    for (var i in a) {
      cost += i['amount'];
    }
    if (a == null) {
      return 0;
    } else {
      return cost;
    }
  }

  getCurrentMonthsExpenditureCost() async {
    var a = await DatabaseHelper()
        .getTransactionsByMonth(DateFormat.yMMMM().format(DateTime.now()));
    int cost = 0;
    for (var i in a) {
      cost += i['amount'];
    }
    if (a == null) {
      return 0;
    } else {
      return cost;
    }
  }

  Future<Map<String, double>> getPieDataMap(String month) async {
    var data = await DatabaseHelper().getTransactionsByMonth(month);
    Map<String, double>
     tempMap = {
      "OTHER": 0.0,
      "FOOD AND DINNING": 0.0,
      "SHOPPING": 0.0,
      "TRAVELLING": 0.0,
      "ENTERTAINMENT": 0.0,
      "MEDICAL": 0.0,
      "PERSONAL CARE": 0.0,
      "EDUCATION": 0.0,
      "BILLS AND UTILITIES": 0.0,
      "INVESTMENTS": 0.0,
      "RENT": 0.0,
      "TAXES": 0.0,
      "INSURANCE": 0.0,
      "GIFTS AND DONATIONS": 0.0,
    };

    for (var transaction in data) {
      if (transaction["category"] == "OTHER") {
        tempMap["OTHER"] += transaction["amount"];
      } else if (transaction["category"] == "FOOD AND DINNING") {
        tempMap["FOOD AND DINNING"] += transaction["amount"];
      } else if (transaction["category"] == "SHOPPING") {
        tempMap["SHOPPING"] += transaction["amount"];
      } else if (transaction["category"] == "TRAVELLING") {
        tempMap["TRAVELLING"] += transaction["amount"];
      } else if (transaction["category"] == "ENTERTAINMENT") {
        tempMap["ENTERTAINMENT"] += transaction["amount"];
      } else if (transaction["category"] == "MEDICAL") {
        tempMap["MEDICAL"] += transaction["amount"];
      } else if (transaction["category"] == "PERSONAL CARE") {
        tempMap["PERSONAL CARE"] += transaction["amount"];
      } else if (transaction["category"] == "EDUCATION") {
        tempMap["EDUCATION"] += transaction["amount"];
      } else if (transaction["category"] == "BILLS AND UTILITIES") {
        tempMap["BILLS AND UTILITIES"] += transaction["amount"];
      } else if (transaction["category"] == "INVESTMENTS") {
        tempMap["INVESTMENTS"] += transaction["amount"];
      } else if (transaction["category"] == "RENT") {
        tempMap["RENT"] += transaction["amount"];
      } else if (transaction["category"] == "TAXES") {
        tempMap["TAXES"] += transaction["amount"];
      } else if (transaction["category"] == "INSURANCE") {
        tempMap["INSURANCEv"] += transaction["amount"];
      } else if (transaction["category"] == "GIFTS AND DONATIONS") {
        tempMap["GIFTS AND DONATIONS"] += transaction["amount"];
      }
    }
    print(tempMap);
    return tempMap;
  }

  getCustomMonthExpenditureCost(String month) async {
    var a = await DatabaseHelper().getTransactionsByMonth(month);
    int cost = 0;
    for (var i in a) {
      cost += i['amount'];
    }
    if (a == null) {
      return 0;
    } else {
      return cost;
    }
  }

  createMonthlyDataList() async {
    List monthData = [];
    var monthBudget = await BudgetDatabaseHelper().getTransactionsList();
    for (var month in monthBudget) {
      var expencesOfMonth = await getCustomMonthExpenditureCost(month["month"]);
      Map tempMap = {};
      tempMap.putIfAbsent("month", () => month["month"]);
      tempMap.putIfAbsent("budget", () => month["amount"]);
      tempMap.putIfAbsent("totalSpent", () => expencesOfMonth);
      monthData.add(tempMap);
      tempMap = {};
    }
    // print(monthData);
    return monthData;
  }

  getDateWiseDataList() async {
    List listDayData = [];
    List checkDuplicateList = [];
    var datesNoted = await DatabaseHelper().getTransactionsList();

    for (var item in datesNoted) {
      Map tempMap = {};
      if (!checkDuplicateList.contains(item['date'])) {
        tempMap.putIfAbsent("date", () => item["date"]);
        listDayData.add(tempMap);
        tempMap = {};
      }
      checkDuplicateList.add(item['date']);
    }
    print(listDayData);
    return listDayData;
  }

  Future<Map<String, List<dynamic>>> getAllTransactionsByDate() async {
    List tempDateData = await getDateWiseDataList();
    Map<String, List<dynamic>> allTransActionsByDate = {};
    for (var item in tempDateData) {
      List dayTransactions =
          await DatabaseHelper().getTodaysTransactions(item["date"]);
      allTransActionsByDate.putIfAbsent(item["date"], () => dayTransactions);
    }
    return allTransActionsByDate;
  }
}
