import 'package:flutter/material.dart';
import 'package:wshop/routes.dart';
import 'package:wshop/api/auth.dart';

void main() async {
  String initalRoute = '/';
  try {
    await isLogin();
    initalRoute = '/';
  } catch (e) {
    initalRoute = '/login';
  }

  runApp(new App(initalRoute));
}

class App extends StatelessWidget {
  final String initalRoute;

  App(this.initalRoute);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
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
