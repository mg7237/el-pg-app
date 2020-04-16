import 'dart:async';

import 'package:el_pg_app/util/preference_connector.dart';
import 'package:el_pg_app/util/route_setting.dart';
import 'package:el_pg_app/util/utility.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var scaffoldState = GlobalKey<ScaffoldState>();
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    bool rememberMe =
        await PreferenceConnector().getBool(PreferenceConnector.REMEMBER_ME_STATUS);
    print(rememberMe);
    if (rememberMe) {
      String userId =
          await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
      if (userId.isEmpty) {
        Navigator.of(context).pushReplacementNamed(LOGIN);
      } else {
        var now = DateTime.now();
        String dateTime = await PreferenceConnector()
            .getString(PreferenceConnector.LOGIN_DATE_TIME);
        DateTime saved = DateTime.parse(dateTime);
        if (now.difference(saved).inDays >= 30) {
          PreferenceConnector().clearAll();
          Navigator.of(context).pushReplacementNamed(LOGIN);
        } else {
          Utility.showErrorSnackBar(scaffoldState, "test");
          Navigator.of(context).pushReplacementNamed(HOME_PAGE);
        }
      }
    } else {
      Navigator.pushReplacementNamed(context,LOGIN);
    }
    //Navigator.of(context).pushReplacementNamed(LOGIN);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldState,
      body: new Center(
        child:
            Hero(tag: "logo", child: Image.asset("assets/icon/login_logo.png")),
      ),
    );
  }
}
