import 'package:flutter/cupertino.dart';
import 'package:wshop/screens/authorization/purchase.dart';
import 'package:wshop/screens/authorization/userAgencyIntro.dart';
import 'package:wshop/screens/friends/fans.dart';
import 'package:wshop/screens/home.dart';
import 'package:wshop/screens/login/launch.dart';
import 'package:wshop/screens/login/mobile.dart';
import 'package:wshop/screens/settings/miniprogram.dart';
import 'package:wshop/screens/settings/profile.dart';
import 'package:wshop/screens/settings/qrcode.dart';
import 'package:wshop/screens/settings/video.dart';
import 'package:wshop/screens/withdraw/fundFlow.dart';
import 'package:wshop/screens/withdraw/withdraw.dart';

final routes = {
  '/login': (settings) =>
      CupertinoPageRoute(builder: (_) => LaunchScreen(), settings: settings),
  '/home': (settings) =>
      CupertinoPageRoute(builder: (_) => HomeScreen(), settings: settings),
  '/login/mobile': (settings) => CupertinoPageRoute(
      builder: (_) => LoginMobileScreen(), settings: settings),
  '/friends/fans': (settings) =>
      CupertinoPageRoute(builder: (_) => FansScreen(), settings: settings),
  '/settings/profile': (settings) =>
      CupertinoPageRoute(builder: (_) => ProfileScreen(), settings: settings),
  '/settings/qrcode': (settings) =>
      CupertinoPageRoute(builder: (_) => QRCodeScreen(), settings: settings),
  '/settings/miniprogram': (settings) =>
      CupertinoPageRoute(builder: (_) => MiniScreen(), settings: settings),
  '/authorization/purchase': (settings) =>
      CupertinoPageRoute(builder: (_) => PurchaseScreen(), settings: settings),
  '/authorization/userAgencyIntro': (settings) => CupertinoPageRoute(
      builder: (_) => UserAgencyIntroScreen(), settings: settings),
  '/withdraw': (settings) =>
      CupertinoPageRoute(builder: (_) => WithdrawScreen(), settings: settings),
  '/fundFlow': (settings) =>
      CupertinoPageRoute(builder: (_) => FundFlowScreen(), settings: settings),
  '/video': (settings) =>
      CupertinoPageRoute(builder: (_) => VideoScreen(), settings: settings),
};
