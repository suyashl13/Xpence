import 'package:flutter/cupertino.dart';

class DbTransaction {
  int id;
  String category;
  String title;
  String date;
  int amount;
  String month;
  
  DbTransaction({
    this.id,
    @required
    this.category,
    @required
    this.title,
    @required
    this.date,
    @required
    this.amount,
    @required
    this.month
    }
  );

  DbTransaction.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.category = map['category'];
    this.title = map['title'];
    this.date = map['date'];
    this.amount = map['amount'];
    this.month = map['month'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> data = {
      'id' : null,
      'category' : this.category,
      'title' : this.title,
      'date' : this.date,
      'amount' : this.amount,
      'month' : this.month
    }; 
    if (this.id != null) {
      data['id'] = this.id;
    }
    return data;
  }
}