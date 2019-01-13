import 'package:flutter/material.dart';
import 'package:wshop/screens/login.dart';
import 'package:wshop/screens/home.dart';
import 'package:wshop/screens/welcome.dart';

final routes = {
  '/': (BuildContext context) => HomeScreen(),
  '/login': (BuildContext context) => LoginScreen(),
  '/welcome': (BuildContext context) => WelcomeScreen(),
};
