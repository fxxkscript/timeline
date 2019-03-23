import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:wshop/api/auth.dart';
import 'package:wshop/routes.dart';

void main() async {
  String initalRoute = '/login';
  try {
    await checkLogin();
    await getUserBasic(context: null);

    initalRoute = '/';
  } catch (e) {
    print(e.toString());
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
          primaryColor: Color.fromARGB(255, 12, 193, 96),
          backgroundColor: Color.fromARGB(255, 237, 237, 237),
          dividerColor: Color.fromARGB(255, 229, 229, 229),
          buttonTheme:
              ButtonThemeData(buttonColor: Color.fromARGB(255, 12, 193, 96)),
          accentColor: Color.fromARGB(255, 172, 172, 172),
//          fontFamily: 'PingFang',
          textTheme: TextTheme(
              headline: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              title: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 19, 19, 19)),
              subtitle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 172, 172, 172)),
              body2: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 83, 102, 147)),
              body1: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 19, 19, 19)),
              caption: TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(255, 19, 19, 19),
                  fontWeight: FontWeight.bold))),
      title: '相册',
      initialRoute: initalRoute,
      routes: routes,
    );
  }
}
