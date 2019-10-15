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
import 'package:wshop/screens/settings/video.dart';
import 'package:wshop/screens/withdraw/fundFlow.dart';
import 'package:wshop/screens/withdraw/withdraw.dart';

final routes = {
  '/login': () => MaterialPageRoute(builder: (_) => LaunchScreen()),
  '/home': () => MaterialPageRoute(builder: (_) => HomeScreen()),
  '/login/mobile': () => MaterialPageRoute(builder: (_) => LoginMobileScreen()),
  '/friends/fans': () => MaterialPageRoute(builder: (_) => FansScreen()),
  '/settings/profile': () => MaterialPageRoute(builder: (_) => ProfileScreen()),
  '/settings/qrcode': () => MaterialPageRoute(builder: (_) => QRCodeScreen()),
  '/authorization/purchase': () =>
      MaterialPageRoute(builder: (_) => PurchaseScreen()),
  '/authorization/userAgencyIntro': () =>
      MaterialPageRoute(builder: (_) => UserAgencyIntroScreen()),
  '/withdraw': () => MaterialPageRoute(builder: (_) => WithdrawScreen()),
  '/fundFlow': () => MaterialPageRoute(builder: (_) => FundFlowScreen()),
  '/freeVideo': () => MaterialPageRoute(builder: (_) => FreeVideo()),
  '/video': () => MaterialPageRoute(builder: (_) => Video()),
};
