import 'package:flutter/material.dart';
import 'package:wshop/screens/home.dart';
import 'package:wshop/screens/login/launch.dart';
import 'package:wshop/screens/login/mobile.dart';
import 'package:wshop/screens/settings/profile.dart';
import 'package:wshop/screens/user.dart';
import 'package:wshop/screens/welcome.dart';

final routes = {
  '/': (BuildContext context) => HomeScreen(),
  '/login': (BuildContext context) => LaunchScreen(),
  '/login/mobile': (BuildContext context) => LoginMobileScreen(),
  '/welcome': (BuildContext context) => WelcomeScreen(),
  '/user': (BuildContext context) => UserScreen(),
  '/settings/profile': (BuildContext context) => ProfileScreen(),
};
