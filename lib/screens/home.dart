import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wshop/screens/tabs/contacts.dart';
import 'package:wshop/screens/tabs/my.dart';
import 'package:wshop/screens/tabs/timeline.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showBroadcast(context));
  }

  showBroadcast(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Text(
              '公告：哇哈哈哈哈哈哈哈哈哈',
              style: Theme.of(context).textTheme.body1,
            ),
            height: 100,
            padding: EdgeInsets.all(10),
          );
        });

    Timer(Duration(seconds: 15), () {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              title: Text('动态'),
              activeIcon: Image.asset('assets/timeline_active.png',
                  width: 22, height: 22),
              icon: Image.asset('assets/timeline.png', width: 22, height: 22)),
          BottomNavigationBarItem(
              title: Text('关注'),
              activeIcon:
                  Image.asset('assets/fav_active.png', width: 22, height: 22),
              icon: Image.asset('assets/fav.png', width: 22, height: 22)),
          BottomNavigationBarItem(
              title: Text('我的'),
              activeIcon:
                  Image.asset('assets/mine_active.png', width: 22, height: 22),
              icon: Image.asset('assets/mine.png', width: 22, height: 22)),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return TimelineTab();
            break;
          case 1:
            return Contacts();
            break;
          case 2:
            return MyTab();
            break;
          default:
            return TimelineTab();
            break;
        }
      },
    );
  }
}
