import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:wshop/screens/app.dart';

import 'api/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String initalRoute = '/';
  try {
    await checkLogin();
    await getUserBasic();

    initalRoute = '/home';
  } catch (e) {
    initalRoute = '/';
  }

  fluwx.registerWxApi(
      appId: 'wx41df20facbec2635',
      universalLink: 'https://api.ippapp.com/share/');
  runApp(App(initalRoute));
}
