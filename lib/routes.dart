import 'package:flutter/material.dart';
import 'package:wshop/screens/authorization/purchase.dart';
import 'package:wshop/screens/authorization/userAgencyIntro.dart';
import 'package:wshop/screens/friends/fans.dart';
import 'package:wshop/screens/home.dart';
import 'package:wshop/screens/login/launch.dart';
import 'package:wshop/screens/login/mobile.dart';
import 'package:wshop/screens/settings/freeVideo.dart';
import 'package:wshop/screens/settings/profile.dart';
import 'package:wshop/screens/settings/qrcode.dart';
import 'package:wshop/screens/welcome.dart';
import 'package:wshop/screens/withdraw/fundFlow.dart';
import 'package:wshop/screens/withdraw/withdraw.dart';

final routes = {
  '/': (BuildContext context) => HomeScreen(),
  '/login': (BuildContext context) => LaunchScreen(),
  '/login/mobile': (BuildContext context) => LoginMobileScreen(),
  '/welcome': (BuildContext context) => WelcomeScreen(),
  '/friends/fans': (BuildContext context) => FansScreen(),
  '/settings/profile': (BuildContext context) => ProfileScreen(),
  '/settings/qrcode': (BuildContext context) => QRCodeScreen(),
  '/authorization/purchase': (BuildContext context) => PurchaseScreen(),
  '/authorization/userAgencyIntro': (BuildContext context) =>
      UserAgencyIntroScreen(),
  '/withdraw': (BuildContext context) => WithdrawScreen(),
  '/fundFlow': (BuildContext context) => FundFlowScreen(),
  '/freeVideo': (BuildContext context) => FreeVideo(),
};
