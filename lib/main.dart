import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:oktoast/oktoast.dart';
import 'package:wshop/api/auth.dart';
import 'package:wshop/routes.dart';
import 'package:wshop/screens/home.dart';
import 'package:wshop/screens/login/launch.dart';
import 'package:wshop/screens/settings/webview.dart';
import 'package:wshop/utils/customRoute.dart';

bool _isAuthenticated = false;

void main() async {
  await FlutterDownloader.initialize();

  WidgetsFlutterBinding.ensureInitialized();
  _isAuthenticated = await checkLogin();
  try {
    await getUserBasic();
  } catch (e) {
    _isAuthenticated = false;
  }

  fluwx.registerWxApi(
      appId: 'wx41df20facbec2635',
      universalLink: 'https://api.ippapp.com/share/');

  runApp(App());
}

class App extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: App.navigatorKey,
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          brightness: Brightness.light,
          primaryColor: Color.fromARGB(255, 12, 193, 96),
          backgroundColor: Color.fromARGB(255, 237, 237, 237),
          scaffoldBackgroundColor: Color.fromARGB(255, 237, 237, 237),
          dividerColor: Color.fromARGB(255, 229, 229, 229),
          primaryColorDark: Color.fromARGB(255, 19, 19, 19),
          buttonTheme:
              ButtonThemeData(buttonColor: Color.fromARGB(255, 12, 193, 96)),
          accentColor: Color.fromARGB(255, 172, 172, 172),
//          fontFamily: 'PingFang',
          textTheme: TextTheme(
              headline: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              title: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 19, 19, 19)),
              subtitle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 172, 172, 172)),
              body2: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 83, 102, 147)),
              body1: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 19, 19, 19)),
              caption: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 19, 19, 19),
                  fontWeight: FontWeight.normal))),
      title: '小杯相册',
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/') {
          return FadeRoute(
            page: () {
              return _isAuthenticated ? HomeScreen() : LaunchScreen();
            }(),
          );
        } else if (settings.name == '/webview') {
          Map args = settings.arguments;

          return SlideTopRoute(
              page: WebViewScreen(title: args['title'], url: args['url']));
        } else {
          return routes[settings.name](settings);
        }
      },
    ));
  }
}
