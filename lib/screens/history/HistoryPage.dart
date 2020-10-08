import 'package:flutter/material.dart';
import 'package:xpence/models/HelperMethods.dart';
import 'package:xpence/screens/history/MonthReviewPage.dart';
import 'package:xpence/screens/home/HomeHelper.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  List monthData;
  List allDatesData;
  Map<String, List<dynamic>> dailyTransactionsMap;
  TabController _controller;

  setHistoryPage() async {
    print("Setting History page....");
    try {
      List tempList = await HelperMethods().createMonthlyDataList();
      List tempDateList = await HelperMethods().getDateWiseDataList();
      Map<String, List<dynamic>> tempDailyTransactionsMap =
          await HelperMethods().getAllTransactionsByDate();
      print(tempList);
      print(tempDateList);
      print("---------------");
      print(tempDailyTransactionsMap);
      setState(() {
        this.monthData = tempList;
        this.allDatesData = tempDateList;
        this.dailyTransactionsMap = tempDailyTransactionsMap;
        this.isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    setHistoryPage();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.00,
        backgroundColor: Color.fromRGBO(86, 35, 73, 1),
        title: Center(
            child: Text(
          "History",
          style: TextStyle(color: Colors.white),
        )),
      ),
      backgroundColor: Color.fromRGBO(86, 35, 73, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 28,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0.8),
            decoration: BoxDecoration(
                color: Colors.white12, borderRadius: BorderRadius.circular(12)),
            width: MediaQuery.of(context).size.width - 72,
            child: Center(
              child: TabBar(
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                          width: 2,
                          style: BorderStyle.solid,
                          color: Color.fromRGBO(158, 97, 152, 1)),
                      insets: EdgeInsets.only(left: 4.6, right: 4.6)),
                  controller: _controller,
                  tabs: [
                    Tab(
                      child: Text(
                        "All",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Tab(
                      child: Text("Monthly",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ]),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
              child: TabBarView(controller: _controller, children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...allDatesData
                              .map((i) => Container(
                                    margin: EdgeInsets.only(top: 12),
                                    width: double.maxFinite,
                                    // color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${i['date'].toString()}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        ...dailyTransactionsMap[
                                                "${i['date'].toString()}"]
                                            .map((i) => Container(
                                                  margin: EdgeInsets.only(
                                                      top: 4, bottom: 4),
                                                  width: double.maxFinite,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      12,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    12),
                                                            decoration: BoxDecoration(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        252,
                                                                        131,
                                                                        66,
                                                                        1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12)),
                                                            child: Icon(
                                                              i['category']
                                                                          .toString() ==
                                                                      "OTHER"
                                                                  ? Icons
                                                                      .brightness_1
                                                                  : i['category'].toString() ==
                                                                          "FOOD AND DINNING"
                                                                      ? Icons
                                                                          .restaurant
                                                                      : i['category'].toString() ==
                                                                              "SHOPPING"
                                                                          ? Icons
                                                                              .shopping_basket
                                                                          : i['category'].toString() == "TRAVELLING"
                                                                              ? Icons.time_to_leave
                                                                              : i['category'].toString() == "ENTERTAINMENT" ? Icons.camera_roll : i["category"].toString() == "MEDICAL" ? Icons.add : i["category"].toString() == "PERSONAL CARE" ? Icons.accessibility_new : i["category"].toString() == "EDUCATION" ? Icons.school : i["category"].toString() == "BILLS AND UTILITIES" ? Icons.attach_money : i["category"].toString() == "GIFTS AND DONATIONS" ? Icons.card_giftcard : Icons.account_balance_wallet,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 18.0),
                                                            child: Center(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "${i['title']}",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  Text(
                                                                    "${HomeHelper().capitalize((i['category'].toString().toLowerCase()))}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white60,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero),
                                                        ],
                                                      ),
                                                      Text(
                                                        "Rs.${i["amount"].toString()}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromRGBO(
                                                              252, 131, 66, 1),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Divider(
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                              .toList(),
                          SizedBox(
                            height: 12,
                          )
                        ],
                      ),
              ),
            ),
            Container(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ListView.builder(
                        itemCount: monthData.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            onTap: () => Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        MonthReviewPage(
                                            monthDataMap: monthData[index]),
                                transitionDuration: Duration(milliseconds: 250),
                                transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) =>
                                    SlideTransition(
                                  position: Tween(
                                          begin: Offset(1.0, 0.0),
                                          end: Offset(0.0, 0.0))
                                      .animate(animation),
                                  child: child,
                                ),
                              ),
                            ),
                            trailing: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(252, 131, 66, 1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "View month",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              "${monthData[index]["month"]}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            subtitle: Text(
                              "\nTotal Spent : ${monthData[index]["totalSpent"]}\nBudget : ${monthData[index]["budget"]}",
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ]))
        ],
      ),
    );
  }
}
