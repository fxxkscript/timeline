import 'package:flutter/material.dart';
import 'package:wshop/routes.dart';
import 'package:wshop/api/auth.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

void main() async {
  String initalRoute = '/login';
  try {
    await isLogin();
    initalRoute = '/';
  } catch (e) {
    initalRoute = '/login';
  }

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
      ),
      title: '相册',
      initialRoute: initalRoute,
      routes: routes,
    );
  }
}
