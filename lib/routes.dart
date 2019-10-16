import 'package:flutter/material.dart';
import 'package:wshop/screens/authorization/purchase.dart';
import 'package:wshop/screens/authorization/userAgencyIntro.dart';
import 'package:wshop/screens/friends/fans.dart';
import 'package:wshop/screens/home.dart';
import 'package:wshop/screens/login/launch.dart';
import 'package:wshop/screens/login/mobile.dart';
import 'package:wshop/screens/settings/profile.dart';
import 'package:wshop/screens/settings/qrcode.dart';
import 'package:wshop/screens/settings/video.dart';
import 'package:wshop/screens/withdraw/fundFlow.dart';
import 'package:wshop/screens/withdraw/withdraw.dart';

final routes = {
  '/login': (settings) =>
      MaterialPageRoute(builder: (_) => LaunchScreen(), settings: settings),
  '/home': (settings) =>
      MaterialPageRoute(builder: (_) => HomeScreen(), settings: settings),
  '/login/mobile': (settings) => MaterialPageRoute(
      builder: (_) => LoginMobileScreen(), settings: settings),
  '/friends/fans': (settings) =>
      MaterialPageRoute(builder: (_) => FansScreen(), settings: settings),
  '/settings/profile': (settings) =>
      MaterialPageRoute(builder: (_) => ProfileScreen(), settings: settings),
  '/settings/qrcode': (settings) =>
      MaterialPageRoute(builder: (_) => QRCodeScreen(), settings: settings),
  '/authorization/purchase': (settings) =>
      MaterialPageRoute(builder: (_) => PurchaseScreen(), settings: settings),
  '/authorization/userAgencyIntro': (settings) => MaterialPageRoute(
      builder: (_) => UserAgencyIntroScreen(), settings: settings),
  '/withdraw': (settings) =>
      MaterialPageRoute(builder: (_) => WithdrawScreen(), settings: settings),
  '/fundFlow': (settings) =>
      MaterialPageRoute(builder: (_) => FundFlowScreen(), settings: settings),
  '/video': (settings) =>
      MaterialPageRoute(builder: (_) => VideoScreen(), settings: settings),
};
