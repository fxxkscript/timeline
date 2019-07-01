import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:wshop/api/auth.dart';
import 'package:wshop/screens/app.dart';

void main() async {
  String initalRoute = '/login';
  try {
    await checkLogin();
    await getUserBasic(context: null);

    initalRoute = '/';
  } catch (e) {
    initalRoute = '/login';
  }

  fluwx.register(appId: 'wx41df20facbec2635');
  runApp(App(initalRoute));
}
