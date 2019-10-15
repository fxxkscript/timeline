import 'package:flutter/material.dart';
import 'package:wshop/api/auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    this.check();
  }

  void check() async {
    String initalRoute;
    try {
      await checkLogin();
      await getUserBasic();

      initalRoute = '/home';
    } catch (e) {
      print(e);
      initalRoute = '/login';
    }
    Navigator.pushReplacementNamed(context, initalRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null, body: Center(child: CircularProgressIndicator()));
  }
}
