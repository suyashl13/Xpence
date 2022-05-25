import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:xpence/db/budget_database_helper.dart';
import 'package:xpence/models/Budget.dart';
import 'package:xpence/screens/bill_remainder/BillReminderPage.dart';
import 'package:xpence/screens/distrubutions/DistrubutionsPage.dart';
import 'package:xpence/screens/history/HistoryPage.dart';
import 'package:xpence/screens/home/HomeHelper.dart';
import 'package:xpence/screens/home/HomePage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool budgetIsSet = false;
  bool isInitalized = false;

  _conditionalCheck() async {
    List temp = await HomeHelper().getBudget();
    if (temp.length == 0) {
      // return setBudgetDialoge();
    } else {
      setState(() {
        budgetIsSet = true;
        isInitalized = true;
      });
    }
  }

  setBudgetDialoge() {
    String bdgt;
    GlobalKey<FormState> _budgetKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context) => Form(
        key: _budgetKey,
        child: SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Center(
                  child: Text(
                "Set Budget",
                style: TextStyle(fontSize: 20),
              )),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(18),
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) => bdgt = value,
                validator: (value) => value.length == 0
                    ? "This fileld is required"
                    : value.trim()[0] == '-'
                        ? "Budget cannot be negative"
                        : value.length > 8
                            ? "Should be smaller than 8 digits."
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
                        BudgetDatabaseHelper().insertTransaction(Budget(
                            month: DateFormat.yMMMM().format(DateTime.now()),
                            amount: int.parse(bdgt)));
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        _conditionalCheck();
                      });
                      Navigator.pop(context);
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

  @override
  void initState() {
    super.initState();
    if (isInitalized == false) {
      _conditionalCheck();
    }
  }

  @override
  Widget build(BuildContext context) {
    List screens = [
      HomePage(),
      HistoryPage(),
      BillReminderPage(),
      DistrubutionPage()
    ];
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: budgetIsSet
              ? screens[_currentIndex]
              : Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height / 18,
                      child: Image(
                          height: MediaQuery.of(context).size.height / 2.1,
                          width: MediaQuery.of(context).size.width,
                          image: AssetImage("assets/unavailable.png")),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipPath(
                          clipper: RoundedDiagonalPathClipper(),
                          child: Container(
                            padding: EdgeInsets.all(74),
                            color: Colors.orange,
                            child: Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text(
                                        "Looks like you havent\nset the budget for ${DateFormat.yMMMM().format(DateTime.now())}.\nPlease set budget and get started.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          72,
                                      child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          onPressed: setBudgetDialoge,
                                          textColor: Colors.white,
                                          color: Color.fromRGBO(86, 35, 73, 1),
                                          child: Text("Set Budget")),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
          bottomNavigationBar: BottomNavigationBar(
              iconSize: 22,
              elevation: 0.0,
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: (i) {
                setState(() {
                  _currentIndex = i;
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), title: Text("")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.history), title: Text("")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.notifications_none), title: Text("")),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.pie_chart_outlined,
                    ),
                    title: Text("")),
              ])),
    );
  }
}
