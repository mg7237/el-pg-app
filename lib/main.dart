import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:el_pg_app/screen/add_new_tenant.dart';
import 'package:el_pg_app/screen/forgot_password_init_page.dart';
import 'package:el_pg_app/screen/forgot_password_page.dart';
import 'package:el_pg_app/screen/home_page.dart';
import 'package:el_pg_app/screen/login_page.dart';
import 'package:el_pg_app/screen/splash_screen.dart';
import 'package:el_pg_app/util/hex_color.dart';
import 'package:el_pg_app/util/route_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription subscription;
  bool showNoInternet = false;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        showNoInternet = true;
      } else {
        showNoInternet = false;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return OverlaySupport(
      child: MaterialApp(
        title: 'EL PG',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: HexColor("#427BFF"),
          accentColor: HexColor("#DC3545"),
        ),
        builder: (context, child) {
          return showNoInternet ? NoInternet() : child;
        },
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          LOGIN: (BuildContext context) => LoginPage(),
          HOME_PAGE: (BuildContext context) => HomePage(),
          FORGOT_PASSWORD_INIT: (BuildContext context) =>
              ForgotPasswordInitPage(),
          FORGOT_PASSWORD: (BuildContext context) => ForgotPasswordPage(),
        },
      ),
    );
  }
}

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset("assets/icon/login_logo.png"),
            Image.asset("assets/no_internet.png"),
          ],
        ),
      ),
    );
  }
}
