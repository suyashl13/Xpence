import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:xpence/models/HelperMethods.dart';
import 'package:xpence/screens/home/HomeHelper.dart';

class DistrubutionPage extends StatefulWidget {
  @override
  _DistrubutionPageState createState() => _DistrubutionPageState();
}

class _DistrubutionPageState extends State<DistrubutionPage> {
  List months = [];
  String activeMonth;
  Map dataMap;
  bool isLoading = true;
  List<Color> colors = [
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.yellowAccent,
    Colors.pink,
    Colors.red,
    Colors.grey,
    Colors.indigo,
    Colors.deepOrange[300],
    Colors.greenAccent,
    Colors.cyan,
    Colors.brown,
    Colors.lightBlueAccent
  ];

  List<String> fields = [
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
  ];
  _setPage() async {
    List tempList = await HelperMethods().createMonthlyDataList();
    for (var item in tempList) {
      months.add(item["month"]);
    }
    dataMap = await HelperMethods().getPieDataMap(months[0]);
    print(dataMap);
    setState(() {
      activeMonth = months[0];
      isLoading = false;
    });
  }

  _setChart(String selectedMonth) async {
    Map<String, double> tempDataMap =
        await HelperMethods().getPieDataMap(selectedMonth);
    setState(() {
      dataMap = tempDataMap;
      activeMonth = selectedMonth;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(
            child: Text("Charts"),
          ),
          elevation: 0.00,
          backgroundColor: Colors.white,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(252, 131, 66, 0.8),
                          borderRadius: BorderRadius.circular(8)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 32),
                      child: DropdownButton<String>(
                        iconEnabledColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        dropdownColor: Color.fromRGBO(252, 131, 66, 1),
                        onChanged: (value) async {
                          setState(() {
                            _setChart(value);
                          });
                        },
                        items: months.map((value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        value: activeMonth,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Divider(
                      thickness: 1.2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PieChart(
                      colorList: colors,
                      dataMap: dataMap,
                      chartRadius: 172,
                      showLegends: false,
                      chartLegendSpacing: 124.0,
                      chartType: ChartType.ring,
                      showChartValueLabel: true,
                      legendPosition: LegendPosition.bottom,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[0],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[0].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[1],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[1].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[2],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[2].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[3],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[3].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[4],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[4].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[5],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[5].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[6],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[6].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[7],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[7].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[8],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[8].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[9],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[9].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[10],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[10].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[11],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[11].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[12],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[12].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          color: colors[13],
                                          child: Padding(
                                              padding: EdgeInsets.all(14)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(HomeHelper().capitalize(
                                              fields[13].toLowerCase())),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }
}
