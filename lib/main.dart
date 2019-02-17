import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:wshop/api/auth.dart';
import 'package:wshop/routes.dart';

void main() async {
  String initalRoute = '/login';
  try {
    checkLogin();

    initalRoute = '/';
  } catch (e) {
    print(e.toString());
    initalRoute = '/login';
  }
  print(initalRoute);

  fluwx.register(appId: 'wx41df20facbec2635');
  runApp(App(initalRoute));
}

class App extends StatelessWidget {
  final String initalRoute;

  App(this.initalRoute);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          brightness: Brightness.light,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],
          fontFamily: 'PingFang',
          textTheme: TextTheme(
              headline: TextStyle(fontSize: 18, fontWeight: FontWeight.w400))),
      title: '相册',
      initialRoute: initalRoute,
      routes: routes,
    );
  }
}
