import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wshop/screens/tabs/my.dart';
import 'package:wshop/screens/tabs/timeline.dart';
import 'package:wshop/screens/tabs/contacts.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  TabController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(title: Text('首页'), icon: Icon(Icons.home)),
          BottomNavigationBarItem(title: Text('通讯录'), icon: Icon(Icons.contacts)),
          BottomNavigationBarItem(
              title: Text('个人中心'), icon: Icon(Icons.person)),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch(index) {
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
