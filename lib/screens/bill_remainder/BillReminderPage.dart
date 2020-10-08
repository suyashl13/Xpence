import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:xpence/screens/home_screen.dart';

class BillReminderPage extends StatefulWidget {
  @override
  _BillReminderPageState createState() => _BillReminderPageState();
}

class _BillReminderPageState extends State<BillReminderPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isLoading = true;
  List pendingNotifications = [];
  Future onSelectNotification(String payload) {
    showDialog(
        context: context,
        builder: (_) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
        });
  }

  showNotification(DateTime scheduledTime, String body, int amount) async {
    var android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description');
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    DateTime scheduledNotificationDateTime = scheduledTime;
    try {
      await flutterLocalNotificationsPlugin.schedule(
          1,
          '$body Payment',
          'Hello, just a remainder you have to pay $amount for ${body} today.',
          scheduledNotificationDateTime,
          platform);
    } catch (e) {
      print(e);
    }
  }

  _deleteRemainder(id) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Alert"),
        content:
            Text("Are you sure want to delete this scheduled notification ?"),
        actions: [
          FlatButton(
              onPressed: () async {
                try {
                  await flutterLocalNotificationsPlugin.cancel(id);
                } catch (e) {
                  print(e);
                }
                _setPage();
                Navigator.pop(context);
              },
              child: Text("Yes")),
          FlatButton(
              onPressed: () => Navigator.pop(context), child: Text("No")),
        ],
      ),
    );
  }

  _removeAllSchNotifications() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "Alert",
        ),
        content: Text("Are you sure want to cancel all scheduled payments."),
        actions: [
          FlatButton(
              onPressed: () {
                flutterLocalNotificationsPlugin.cancelAll();
                _setPage();
                Navigator.pop(context);
              },
              child: Text("Yes")),
          FlatButton(onPressed: () => Navigator.pop(context), child: Text("No"))
        ],
      ),
    );
  }

  _addPaymentRemainder(BuildContext ctx) {
    DateTime date;
    var setDate = "Pick Date";
    String bill_payable;
    int amount_payable;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return showDialog(
      context: ctx,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          child: SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Add a Payment Remainder",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Divider()),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      margin: EdgeInsets.symmetric(horizontal: 14),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onSaved: (newValue) {
                                setState.call(() {
                                  bill_payable = newValue;
                                });
                              },
                              validator: (value) => value.length == 0
                                  ? "This fileld is required"
                                  : value.length >= 14
                                      ? "This fileld cannot be greater than 14 characters."
                                      : null,
                              decoration: InputDecoration(
                                  labelText: "Payment / Bill",
                                  hintText: "Ex. Electricity bill",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              onSaved: (newValue) {
                                setState.call(() {
                                  amount_payable = int.parse(newValue);
                                });
                              },
                              keyboardType: TextInputType.number,
                              validator: (value) => value.length == 0
                                  ? "This fileld is required"
                                  : value.trim()[0] == "-"
                                      ? "Amount cannot be negative."
                                      : value.length >= 6
                                          ? "Amount cannot be greater than 6 digit."
                                          : null,
                              decoration: InputDecoration(
                                  labelText: "Amount",
                                  hintText: "Ex. 1200",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 18),
                              width: double.maxFinite,
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  onPressed: () {
                                    showDatePicker(
                                      context: ctx,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2050),
                                    ).then((value) {
                                      setState.call(() {
                                        try {
                                          setDate =
                                              DateFormat.yMMMd().format(value);
                                          date = value;
                                        } catch (e) {}
                                      });
                                    });
                                  },
                                  color: Color.fromRGBO(252, 131, 66, 1),
                                  textColor: Colors.white,
                                  child: Text(setDate)),
                            ),
                            Container(
                              width: double.maxFinite,
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      if (date == null) {
                                        Scaffold.of(ctx).showSnackBar(SnackBar(
                                            backgroundColor: Colors.red,
                                            duration:
                                                Duration(milliseconds: 1500),
                                            content: Text(
                                                "Please select date and try again.")));
                                        print(bill_payable);
                                      }
                                      try {
                                        showNotification(
                                            date, bill_payable, amount_payable);
                                      } catch (e) {
                                        print(e);
                                      }
                                      Navigator.pop(context);
                                      _setPage();
                                      Scaffold.of(ctx).showSnackBar(SnackBar(
                                          backgroundColor:
                                              Color.fromRGBO(252, 131, 66, 1),
                                          duration:
                                              Duration(milliseconds: 1200),
                                          content: Text(
                                              "Sucessfully added reminder.")));
                                    }
                                  },
                                  color: Color.fromRGBO(252, 131, 66, 1),
                                  textColor: Colors.white,
                                  child: Text("Done")),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _setPage() async {
    try {
      List tempPendingNotifications =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      print(tempPendingNotifications);
      setState(() {
        this.pendingNotifications = tempPendingNotifications;
        this.isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings);
    _setPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        backgroundColor: Color.fromRGBO(86, 35, 73, 1),
        appBar: AppBar(
          elevation: 0.00,
          backgroundColor: Color.fromRGBO(86, 35, 73, 1),
          title: Center(
              child: Text(
            "Payment Reminders",
            style: TextStyle(color: Colors.white),
          )),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                _addPaymentRemainder(context);
              },
              child: Container(
                margin: EdgeInsets.only(top: 24, left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white10,
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.add_alert,
                    color: Colors.white,
                  ),
                  title: Text("Add a payment remainder",
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
            ),
            GestureDetector(
              onTap: _removeAllSchNotifications,
              child: Container(
                margin: EdgeInsets.only(top: 12, left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white10,
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.notifications_off,
                    color: Colors.white,
                  ),
                  title: Text("Remove all scheduled payment remainder(s)",
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12, left: 14, right: 14),
              child: Divider(
                color: Colors.white,
              ),
            ),
            Container(
                margin:
                    EdgeInsets.only(top: 12, left: 14, right: 14, bottom: 8),
                child: Text(
                  "Payment reminders",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )),
            Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: pendingNotifications.length,
                        itemBuilder: (context, index) => ListTile(
                          trailing: GestureDetector(
                            onTap: () {
                              _deleteRemainder(pendingNotifications[index].id);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          leading: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color.fromRGBO(252, 131, 66, 1)),
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.notifications,
                                  color: Colors.white)),
                          title: Text(
                            "${pendingNotifications[index].title}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ))
          ],
        ));
  }
}
