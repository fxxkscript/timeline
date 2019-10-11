import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wshop/routes.dart';

class App extends StatelessWidget {
  final String initialRoute;

  App(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          brightness: Brightness.light,
          primaryColor: Color.fromARGB(255, 12, 193, 96),
          backgroundColor: Color.fromARGB(255, 237, 237, 237),
          scaffoldBackgroundColor: Color.fromARGB(255, 237, 237, 237),
          dividerColor: Color.fromARGB(255, 229, 229, 229),
          primaryColorDark: Color.fromARGB(255, 19, 19, 19),
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
                  fontSize: 12,
                  color: Color.fromARGB(255, 19, 19, 19),
                  fontWeight: FontWeight.normal))),
      title: '相册',
      initialRoute: initialRoute,
      routes: routes,
    ));
  }
}
