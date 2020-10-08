import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:xpence/db/database_helper.dart';
import 'package:xpence/screens/home/HomeHelper.dart';

// ignore: must_be_immutable
class MonthReviewPage extends StatefulWidget {
  Map monthDataMap;

  MonthReviewPage({@required this.monthDataMap});

  @override
  _MonthReviewPageState createState() =>
      _MonthReviewPageState(monthDataMap: this.monthDataMap);
}

class _MonthReviewPageState extends State<MonthReviewPage> {
  Map monthDataMap;
  List monthTransactions;
  _MonthReviewPageState({@required this.monthDataMap});
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    setMonthReviewPage(monthDataMap['month']);
  }

  transactionDetailDialogBox(Map transaction, BuildContext ctx) {
    print(transaction);
    return showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "${transaction['title']}",
        ),
        content: Text(
            "Amount Spent : ${transaction['amount']}\nCategory : ${HomeHelper().capitalize(transaction['category'].toString().toLowerCase())}"),
        actions: [
          FlatButton(
              onPressed: () {
                return showDialog(
                  context: ctx,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: Text(
                      "Alert",
                    ),
                    content:
                        Text("Are you sure want to delete the transaction."),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            DatabaseHelper()
                                .deleteTransaction(transaction['id']);
                            setMonthReviewPage(monthDataMap['month']);
                            Navigator.pop(ctx);
                            Navigator.pop(ctx);
                          },
                          child: Text("Yes")),
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          child: Text("No")),
                    ],
                  ),
                );
              },
              textColor: Colors.red,
              child: Text("Delete")),
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Okay")),
        ],
      ),
    );
  }

  setMonthReviewPage(String monthYear) async {
    List data = await DatabaseHelper().getTransactionsByMonth(monthYear);
    print(data);
    setState(() {
      this.monthTransactions = data;
      this.isLoading = false;
    });
  }

  monthDetailsDialogueBox() {
    print(monthDataMap);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "${this.monthDataMap['month']}",
        ),
        content: Text(
          "Budget : ${this.monthDataMap['budget']}\nTotal Spent : ${monthDataMap['totalSpent']}",
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Okay"),
            textColor: Color.fromRGBO(252, 131, 66, 1),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(245, 244, 250, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(245, 244, 250, 1),
          elevation: 0.00,
          title: Center(child: Text("${monthDataMap["month"]}")),
          actionsIconTheme: IconThemeData.fallback(),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(
                child: Icon(Icons.info_outline),
                onTap: monthDetailsDialogueBox,
              ),
            )
          ],
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClipPath(
                  clipper: OvalTopBorderClipper(),
                  child: Container(
                    color: Color.fromRGBO(86, 35, 73, 1),
                    height: MediaQuery.of(context).size.height / 1.8,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(padding: EdgeInsets.zero),
                Padding(padding: EdgeInsets.zero),
                Padding(padding: EdgeInsets.zero),
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14)),
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: monthTransactions.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color.fromRGBO(252, 131, 66, 1)),
                                child: Icon(
                                  monthTransactions[index]['category'].toString() == "OTHER"
                                      ? Icons.brightness_1
                                      : monthTransactions[index]['category'].toString() == "FOOD AND DINNING"
                                          ? Icons.restaurant
                                          : monthTransactions[index]['category'].toString() == "SHOPPING"
                                              ? Icons.shopping_basket
                                              : monthTransactions[index]
                                                              ['category']
                                                          .toString() ==
                                                      "TRAVELLING"
                                                  ? Icons.time_to_leave
                                                  : monthTransactions[index]
                                                                  ['category']
                                                              .toString() ==
                                                          "ENTERTAINMENT"
                                                      ? Icons.camera_roll
                                                      : monthTransactions[index]["category"].toString() == "MEDICAL"
                                                          ? Icons.add
                                                          : monthTransactions[index]["category"].toString() ==
                                                                  "PERSONAL CARE"
                                                              ? Icons
                                                                  .accessibility_new
                                                              : monthTransactions[index]["category"].toString() == "EDUCATION"
                                                                  ? Icons.school
                                                                  : monthTransactions[index]["category"].toString() == "BILLS AND UTILITIES"
                                                                      ? Icons.attach_money
                                                                      : monthTransactions[index]["category"].toString() == "GIFTS AND DONATIONS" ? Icons.card_giftcard : Icons.account_balance_wallet,
                                  color: Colors.white,
                                ),
                              ),
                              title:
                                  Text("${monthTransactions[index]["title"]}"),
                              subtitle: Text(
                                  "${HomeHelper().capitalize((monthTransactions[index]["category"].toString().toLowerCase()))} (${monthTransactions[index]["date"]})"),
                              trailing: Container(
                                child: Text(
                                  "Rs.${monthTransactions[index]["amount"]}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(252, 131, 66, 1)),
                                ),
                              ),
                              onTap: () => transactionDetailDialogBox(
                                  monthTransactions[index], context),
                            ),
                          ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
