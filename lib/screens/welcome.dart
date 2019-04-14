import 'package:flutter/material.dart';
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

    // isLogin().then((result) {
    //   if (result.token.isNotEmpty) {
    //     Navigator.pushReplacementNamed(context, '/home');
    //   }
    // }).catchError((onError) {
    //   print(onError);
    //   Navigator.pushReplacementNamed(context, '/login');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null, body: Center(child: CircularProgressIndicator()));
  }
}
