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
