import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:wshop/api/auth.dart';

import '../../main.dart';

class LaunchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LaunchScreenState();
  }
}

class LaunchScreenState extends State<LaunchScreen> {
  StreamSubscription handler;
  bool _isLoading = false;
  bool installedWechat = false;

  void _wechat() async {
    await fluwx.sendWeChatAuth(
        scope: "snsapi_userinfo", state: "wechat_sdk_demo_test");
  }

  void checkWechat() async {
    bool installed = await fluwx.isWeChatInstalled();
    if (installed) {
      setState(() {
        installedWechat = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // hide status bar
//    SystemChrome.setEnabledSystemUIOverlays([]);

    // show status bar
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values)
//    check();

    handler = fluwx.responseFromAuth.listen((response) async {
      setState(() => _isLoading = true);
      bool success = await loginByWechat(response.code);
      await getUserBasic();
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      }
    });

    checkWechat();
  }

  check() async {
    try {
      await checkLogin();

      App.navigatorKey.currentState.pushReplacementNamed('/home');
    } catch (e) {
      print(e);
      return;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    handler.cancel();

    super.dispose();
  }

  Widget btnTheme({Widget child}) {
    return ButtonTheme(
      minWidth: 10,
      height: 10,
      padding: EdgeInsets.all(0),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    if (installedWechat) {
      buttons.add(btnTheme(
        child: FlatButton(
          child: Container(
              width: 160,
              height: 44,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 12, 193, 96),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    child: Image.asset('assets/wechat_icon.png',
                        width: 19, height: 16),
                    padding: EdgeInsets.only(right: 10),
                  ),
                  Text('微信登录',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: Colors.white))
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )),
          onPressed: _wechat,
        ),
      ));
    }
    buttons.add(btnTheme(
        child: FlatButton(
      child: Container(
          width: 160,
          height: 44,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 248, 248, 248),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: <Widget>[
              Text('手机号登录',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(color: Color.fromARGB(255, 12, 193, 96)))
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )),
      onPressed: () {
        Navigator.pushNamed(context, '/login/mobile');
      },
    )));

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: null,
            body: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset('assets/login_bg_top.png',
                            width: 235, height: 115),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset('assets/login_btn_icon_1.png',
                              width: 40, height: 40),
                          margin: EdgeInsets.only(left: 22, right: 15),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '登录',
                              style: Theme.of(context).textTheme.title.copyWith(
                                  height: 0.9,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '登录后才能看到团队动态',
                              style: Theme.of(context).textTheme.subtitle,
                            )
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset('assets/login_btn_icon_2.png',
                            width: 120, height: 24),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset('assets/login_bg_middle.png',
                            width: 235, height: 91),
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 22,
                          maxHeight: 100),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: buttons,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Row(
                            children: <Widget>[
                              Text('登录即表明你已同意小杯相册的',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle
                                      .copyWith(fontSize: 10)),
                              btnTheme(
                                child: FlatButton(
                                  child: Text('使用条款',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body2
                                          .copyWith(fontSize: 10)),
                                  onPressed: () {
                                    // TODO open view
                                    Navigator.of(context).pushNamed('/webview',
                                        arguments: {
                                          'url':
                                              'https://m.ippapp.com/agreement.html',
                                          'title': '使用条款'
                                        });
                                  },
                                ),
                              ),
                              Text(' 和 ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle
                                      .copyWith(fontSize: 10)),
                              btnTheme(
                                child: FlatButton(
                                  child: Text('隐私协议',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body2
                                          .copyWith(fontSize: 10)),
                                  onPressed: () {
                                    // TODO open view
                                    Navigator.of(context).pushNamed('/webview',
                                        arguments: {
                                          'url':
                                              'https://m.ippapp.com/license.html',
                                          'title': '隐私协议'
                                        });
                                  },
                                ),
                              ),
                              Text('。',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle
                                      .copyWith(fontSize: 10))
                            ],
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ))));
  }
}
