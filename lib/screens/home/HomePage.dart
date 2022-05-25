import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xpence/db/budget_database_helper.dart';
import 'package:xpence/db/database_helper.dart';
import 'package:xpence/models/Budget.dart';
import 'package:xpence/models/HelperMethods.dart';
import 'package:xpence/models/Transaction.dart';
import 'package:xpence/screens/home/HomeHelper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String title, amount;
  String category = "OTHER";
  List recentTransactions = [];
  int budget, totalSpent;
  var remaining;
  double progress;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _setPage();
    });
  }

  _editBudgetDialoge() async {
    List temp = await BudgetDatabaseHelper()
        .getCurrentMonthBudget(DateFormat.yMMMM().format(DateTime.now()));
    GlobalKey<FormState> _budgetKey = GlobalKey<FormState>();
    int bdgt = this.budget;

    return showDialog(
      context: context,
      builder: (context) => Form(
        key: _budgetKey,
        child: SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Center(
                  child: Text(
                "Edit Budget",
                style: TextStyle(fontSize: 18),
              )),
            ),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.all(18),
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) => bdgt = int.parse(value),
                validator: (value) => value.length == 0
                    ? "This fileld is required"
                    : value.trim()[0] == "-"
                        ? "Budget cannot be negative."
                        : value.length >= 6
                            ? "Budget cannot be greater than 6 digit."
                            : null,
                decoration: InputDecoration(
                    labelText: 'Budget', border: OutlineInputBorder()),
              ),
            ),
            Center(
              child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: () {
                    if (_budgetKey.currentState.validate()) {
                      _budgetKey.currentState.save();
                      try {
                        BudgetDatabaseHelper().updateTransactionByMonth(Budget(
                            id: temp[0]["id"],
                            month: DateFormat.yMMMM().format(DateTime.now()),
                            amount: bdgt));
                        setState(() {
                          _setPage();
                        });
                        Navigator.pop(context);
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  textColor: Colors.white,
                  color: Color.fromRGBO(252, 131, 66, 1),
                  child: Text("Done")),
            )
          ],
        ),
      ),
    );
  }

  _setPage() async {
    try {
      List temp = await BudgetDatabaseHelper()
          .getCurrentMonthBudget(DateFormat.yMMMM().format(DateTime.now()));
      HomeHelper().throwToSetbudget(temp, context);
      int budget = temp[0]['amount'];
      List recentTransactions = await DatabaseHelper()
          .getTodaysTransactions(DateFormat.yMMMd().format(DateTime.now()));
      int totalSpent = await HelperMethods().getCurrentMonthsExpenditureCost();
      var progress = HomeHelper().getProgressValue(totalSpent, budget);
      var remaining = budget - totalSpent;
      setState(() {
        this.budget = budget;
        this.recentTransactions = recentTransactions;
        this.totalSpent = totalSpent;
        this.progress = progress;
        this.remaining = remaining;
      });
    } catch (e) {
      print(e);
    }
    print("----------------------------");
    print("budget : " + budget.toString());
    print("Recent transactions : " + recentTransactions.toString());
    print("total spent : " + totalSpent.toString());
    print("Progress : " + progress.toString());
  }

  Future<void> _noteAnExpenditure() async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String _category = "OTHER";
    String _product;
    int _amount;
    return showDialog(
      context: context,
      builder: (BuildContext bcontext) => StatefulBuilder(
          builder: (mcontext, setState) => Form(
              key: _formKey,
              child: Center(
                child: SimpleDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Note Transaction",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Divider(),
                          SizedBox(height: 4,),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 2),
                            child: TextFormField(
                              validator: (i) {
                                if (i.length == 0) {
                                  return "This field is required";
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  _product = value;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: "Product",
                                  border: OutlineInputBorder(),
                                  hintText: "Enter product"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: TextFormField(
                              // ignore: missing_return
                              validator: (i) {
                                if (i.length == 0) {
                                  return "This field is required";
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  _amount = int.parse(value);
                                });
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: "Amount",
                                  border: OutlineInputBorder(),
                                  hintText: "Enter amount you spent"),
                            ),
                          ),
                          Center(
                            child: DropdownButton<String>(
                              items: [
                                "OTHER",
                                "FOOD AND DINNING",
                                "SHOPPING",
                                "TRAVELLING",
                                "ENTERTAINMENT",
                                "MEDICAL",
                                "PERSONAL CARE",
                                "EDUCATION",
                                "BILLS AND UTILITIES",
                                "INVESTMENTS",
                                "RENT",
                                "TAXES",
                                "INSURANCE",
                                "GIFTS AND DONATIONS",
                              ].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _category = val;
                                  print(_category);
                                });
                              },
                              value: _category,
                              hint: Text("Select"),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          FlatButton(
                            child: Text(
                              "Add Transaction",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                DbTransaction _dbtransaction;
                                setState(() {
                                  _dbtransaction = DbTransaction(
                                      category: _category,
                                      title: _product,
                                      date: DateFormat.yMMMd()
                                          .format(DateTime.now()),
                                      amount: _amount,
                                      month: DateFormat.yMMMM()
                                          .format(DateTime.now()));
                                });
                                try {
                                  var a = await DatabaseHelper()
                                      .insertTransaction(_dbtransaction);
                                  print(a);
                                  _setPage();
                                  Navigator.pop(context);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      duration: Duration(milliseconds: 1200),
                                      backgroundColor:
                                          Color.fromRGBO(252, 131, 66, 1),
                                      content: Text(
                                          "Expenditure added successfully.")));
                                } catch (e) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      duration: Duration(seconds: 2),
                                      backgroundColor:
                                          Color.fromRGBO(183, 150, 255, 1),
                                      content:
                                          Text("Failed to add expenditure.")));
                                }
                              }
                            },
                            color: Color.fromRGBO(252, 131, 66, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 244, 250, 1),
      appBar: AppBar(
        title: Center(
          child: Text("Xpence"),
        ),
        backgroundColor: Color.fromRGBO(245, 244, 250, 1),
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.settings,
              color: Color.fromRGBO(86, 35, 73, 1),
            ),
            onPressed: () => HomeHelper().settingsDialogueBox(context)),
        actions: [Padding(padding: EdgeInsets.all(18))],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 3.7,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(86, 35, 73, 1),
                  borderRadius: BorderRadius.circular(18)),
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${DateFormat.yMMMM().format(DateTime.now()).toUpperCase()}",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(padding: EdgeInsets.zero),
                  LinearProgressIndicator(
                    minHeight: 28,
                    value: progress == null ? 0 : progress,
                    backgroundColor: Color.fromRGBO(252, 131, 66, 0.38),
                    valueColor:
                        AlwaysStoppedAnimation(Color.fromRGBO(252, 131, 66, 1)),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total spent : ${totalSpent}",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      Text(
                        "Budget : ${budget}",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      Text(
                        "Remaining : ${remaining}",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 17,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _noteAnExpenditure,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      height: MediaQuery.of(context).size.height / 12,
                      width: MediaQuery.of(context).size.width / 2.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(252, 131, 66, 1),
                                borderRadius: BorderRadius.circular(12)),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          Center(
                              child: Text(
                            "Add Transaction",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(86, 35, 73, 1),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _editBudgetDialoge,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      height: MediaQuery.of(context).size.height / 12,
                      width: MediaQuery.of(context).size.width / 2.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(252, 131, 66, 1),
                                borderRadius: BorderRadius.circular(12)),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          Center(
                              child: Text(
                            "Edit Budget",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(86, 35, 73, 1),
                            ),
                          )),
                          Padding(padding: EdgeInsets.zero),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Text(
              "Recent Transactions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(86, 35, 73, 1),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 48,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...recentTransactions
                        .map(
                          (i) => Container(
                            margin: EdgeInsets.only(bottom: 12),
                            height: MediaQuery.of(context).size.height / 14,
                            width: double.maxFinite - 18,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(252, 131, 66, 1),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Icon(
                                        i['category'].toString() == "OTHER"
                                            ? Icons.brightness_1
                                            : i['category'].toString() ==
                                                    "FOOD AND DINNING"
                                                ? Icons.restaurant
                                                : i['category'].toString() ==
                                                        "SHOPPING"
                                                    ? Icons.shopping_basket
                                                    : i['category'].toString() ==
                                                            "TRAVELLING"
                                                        ? Icons.time_to_leave
                                                        : i['category'].toString() ==
                                                                "ENTERTAINMENT"
                                                            ? Icons.camera_roll
                                                            : i["category"]
                                                                        .toString() ==
                                                                    "MEDICAL"
                                                                ? Icons.add
                                                                : i["category"]
                                                                            .toString() ==
                                                                        "PERSONAL CARE"
                                                                    ? Icons
                                                                        .accessibility_new
                                                                    : i["category"].toString() ==
                                                                            "EDUCATION"
                                                                        ? Icons
                                                                            .school
                                                                        : i["category"].toString() == "BILLS AND UTILITIES"
                                                                            ? Icons
                                                                                .attach_money
                                                                            : i["category"].toString() == "GIFTS AND DONATIONS"
                                                                                ? Icons.card_giftcard
                                                                                : Icons.account_balance_wallet,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 18.0),
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${i['title']}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    86, 35, 73, 1),
                                              ),
                                            ),
                                            Text(
                                              "${HomeHelper().capitalize((i['category'].toString().toLowerCase()))}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    86, 35, 73, 0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.zero),
                                  ],
                                ),
                                Text(
                                  "Rs.${i["amount"].toString()}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(252, 131, 66, 1),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                        .toList()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
