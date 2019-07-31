import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wshop/api/my.dart';
import 'package:wshop/models/notice.dart';
import 'package:wshop/screens/tabs/contacts.dart';
import 'package:wshop/screens/tabs/my.dart';
import 'package:wshop/screens/tabs/timeline.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    this.initData();
  }

  void initData() async {
    Notice notice = await getNotice();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => showNotice(context, notice));
  }

  void showNotice(BuildContext context, Notice notice) async {
    if (notice.content == null || notice.content.isEmpty) {
      return;
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Color.fromARGB(200, 237, 237, 237),
      content: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Flexible(
            child: Container(
                child: Text(
          notice.content,
          style: Theme.of(context).textTheme.body1,
        ))),
        IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).primaryColorDark),
          tooltip: '关闭',
          onPressed: () {
            _scaffoldKey.currentState.removeCurrentSnackBar();
          },
        ),
      ]),
      duration: Duration(seconds: notice.duration),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return Scaffold(
        key: _scaffoldKey,
        body: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  title: Text('动态'),
                  activeIcon: Image.asset('assets/timeline_active.png',
                      width: 22, height: 22),
                  icon: Image.asset('assets/timeline.png',
                      width: 22, height: 22)),
              BottomNavigationBarItem(
                  title: Text('关注'),
                  activeIcon: Image.asset('assets/fav_active.png',
                      width: 22, height: 22),
                  icon: Image.asset('assets/fav.png', width: 22, height: 22)),
              BottomNavigationBarItem(
                  title: Text('我的'),
                  activeIcon: Image.asset('assets/mine_active.png',
                      width: 22, height: 22),
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
        ));
  }
}
