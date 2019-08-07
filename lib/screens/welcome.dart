import 'package:flutter/material.dart';
import 'package:wshop/api/auth.dart';
import 'package:wshop/models/auth.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomeScreenState();
  }
}

class WelcomeScreenState extends State<WelcomeScreen> {
  Future<Auth> _auth;

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

      initalRoute = '/';
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
