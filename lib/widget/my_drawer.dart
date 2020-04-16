import 'package:el_pg_app/screen/splash_screen.dart';
import 'package:el_pg_app/util/preference_connector.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          ListTile(
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              logoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  logoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Are you sure, you want to logout?"),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  PreferenceConnector()
                      .setBool(PreferenceConnector.REMEMBER_ME_STATUS, false);
                  /*final FirebaseMessaging _fireBaseMessaging = FirebaseMessaging();
                  _fireBaseMessaging.unsubscribeFromTopic('applicants');
                  _fireBaseMessaging.unsubscribeFromTopic('tenants');*/
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                      (Route<dynamic> route) => false);
                },
              )
            ],
          );
        });
  }
}
