import 'package:fluttericon/font_awesome_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xpence/db/budget_database_helper.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:xpence/db/database_helper.dart';
import 'package:xpence/screens/home_screen.dart';

class HomeHelper {
  getBudget() async {
    try {
      var result = await BudgetDatabaseHelper()
          .getCurrentMonthBudget(DateFormat.yMMMM().format(DateTime.now()));
      print(result);
      return result;
    } catch (e) {
      print(e);
    }
  }

  getProgressValue(int totalSpent, int budget) {
    if (totalSpent > budget) {
      return 1.0;
    } else {
      double result = totalSpent / budget;
      return result;
    }
  }

  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError("string: $string");
    }
    if (string.isEmpty) {
      return string;
    }
    return string[0].toUpperCase() + string.substring(1);
  }

  resetApplication(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Container(
          child: Text("Are you sure want to reset app ?"),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                try {
                  await DatabaseHelper().turnCateTransactions();
                  await BudgetDatabaseHelper().turncateBudget();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ));
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Yes")),
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No")),
        ],
      ),
    );
  }

  sendReccommondMail() async {
    const emailaddress =
        'mailto:suyash.lawand@gmail.com?subject=Suggesting an idea for Xpence app.&body=';
    if (await canLaunch(emailaddress)) {
      await launch(emailaddress);
    } else {
      throw 'Could not Email';
    }
  }

  sendBugMail() async {
    const emailaddress =
        'mailto:suyash.lawand@gmail.com?subject=Reporting a bug in Xpence app.&body=';
    if (await canLaunch(emailaddress)) {
      await launch(emailaddress);
    } else {
      throw 'Could not Email';
    }
  }

  Future<void> _followUsDialoguebox(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        children: <Widget>[
          Container(
            child: ListTile(
                title: Center(
                    child: Text(
              "Follow us",
              style: TextStyle(fontSize: 20),
            ))),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 12),
            color: Color.fromRGBO(252, 131, 66, 1),
            child: ListTile(
              title: Center(
                  child: Text(
                "@suyeshlawand",
                style: TextStyle(color: Colors.white),
              )),
              onTap: () async {
                const url = 'https://www.instagram.com/suyeshlawand/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 12),
            color: Color.fromRGBO(252, 131, 66, 1),
            child: ListTile(
              title: Center(
                  child: Text(
                "@pachack_studio",
                style: TextStyle(color: Colors.white),
              )),
              onTap: () async {
                const url = 'https://www.instagram.com/pachack_studio/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  settingsDialogueBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        children: [
          Padding(
            padding: EdgeInsets.all(24),
            child:
                Center(child: Text("Settings", style: TextStyle(fontSize: 22))),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.restore),
            title: Text("Reset Application"),
            subtitle: Text("Delete all records."),
            onTap: () => resetApplication(context),
          ),
          ListTile(
            leading: Icon(Icons.mail_outline),
            title: Text("Recommend us"),
            subtitle: Text("Suggest us how can we improve application."),
            onTap: sendReccommondMail,
          ),
          ListTile(
            leading: Icon(FontAwesome.bug),
            title: Text("Report a bug"),
            subtitle: Text("Inform us if anything goes wrong."),
            onTap: sendBugMail,
          ),
          ListTile(
            leading: Icon(FontAwesome.instagram),
            title: Text("Follow us"),
            subtitle: Text("Follow us on instagram"),
            onTap: () => _followUsDialoguebox(context),
          ),
        ],
      ),
    );
  }

  throwToSetbudget(var temp, BuildContext context) {
    if (temp == null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    }
  }
}
