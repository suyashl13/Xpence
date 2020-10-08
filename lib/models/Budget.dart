import 'package:flutter/cupertino.dart';

class Budget {
  int id;
  String month;
  int amount;

  Budget({this.id, @required this.month, @required this.amount});

  Budget.formMap(Map<String, dynamic> budgetData) {
    this.id = budgetData['id'];
    this.month = budgetData['month'];
    this.amount = budgetData['amount'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "id": this.id,
      "month": this.month,
      "amount": this.amount
    };
    return data;
  }
}
