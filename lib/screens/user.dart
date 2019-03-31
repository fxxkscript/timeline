import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wshop/api/feeds.dart';
import 'package:wshop/models/auth.dart';
import 'package:wshop/models/feeds.dart';

class UserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserScreenState();
  }
}

class UserScreenState extends State<UserScreen> {
  static const channel = const MethodChannel('com.doraemon.meizizi/door');
  List<Feed> _items = [];
  Feeds feeds;
  int alpha = 0;

  Future<void> _share(List<String> pics) async {
    try {
      final int result = await channel.invokeMethod('weixin', pics);
      debugPrint(result.toString());
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    _getList();
  }

  Future<void> _getList() async {
    if (feeds != null && !feeds.hasNext) {
      return;
    }

    int cursor = feeds != null ? feeds.nextCursor : 0;

    feeds = await getTimeline(context, cursor);

    setState(() {
      _items.addAll(feeds.list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(children: [
        RefreshIndicator(
            displacement: 80,
            onRefresh: () {
              setState(() {
                _items.clear();
              });
              return _getList();
            },
            child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels > 200) {
                    this.setState(() {
                      alpha = 255;
                    });
                  } else {
                    this.setState(() {
                      alpha = 0;
                    });
                  }
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    _getList();
                  }
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: _items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        height: 300,
                        child: Stack(children: [
                          Image.asset(
                            'assets/bg.png',
                            height: 211,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            left: 12,
                            top: 89,
                            child: ClipRRect(
                              child: Image.network(Auth().avatar,
                                  width: 64, height: 64, fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          Positioned(
                            left: 92,
                            top: 101,
                            child: Text(Auth().nickname,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .copyWith(color: Colors.white)),
                          ),
                          Positioned(
                            left: 92,
                            top: 129,
                            child: Text('知耻而后勇，后来者居上。',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .copyWith(
                                        color: Colors.white, fontSize: 12)),
                          ),
                          Positioned(
                            left: 92,
                            top: 166,
                            child: Text('上新 20                总数 100',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .copyWith(
                                        color: Colors.white, fontSize: 12)),
                          ),
                          Positioned(
                            right: 12,
                            top: 108,
                            child: FlatButton(
                              onPressed: () {},
                              child: Container(
                                width: 90,
                                height: 27,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                    child: Text(
                                  '关注',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 12, 193, 96)),
                                )),
                              ),
                            ),
                          )
                        ]),
                      );
                    }
                    index = index - 1;
                    return Container(
                        decoration: BoxDecoration(),
                        padding: EdgeInsets.only(bottom: 10, right: 20),
                        margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        child: Stack(children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 80,
                                  height: 100,
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Text('12',
                                            style: Theme.of(context)
                                                .textTheme
                                                .title
                                                .copyWith(fontSize: 30)),
                                      ),
                                      Positioned(
                                          left: 40,
                                          top: 16,
                                          child: Text('12月',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .title
                                                  .copyWith(fontSize: 12))),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 74,
                                  height: 74,
                                  margin: EdgeInsets.only(right: 10),
                                  child: Stack(
                                    children: <Widget>[
                                      Wrap(
                                        spacing: 2,
                                        runSpacing: 2,
                                        children: <Widget>[
                                          Image.asset('assets/share.png',
                                              width: 36, height: 36),
                                          Image.asset('assets/share.png',
                                              width: 36, height: 36),
                                          Image.asset('assets/share.png',
                                              width: 36, height: 36),
                                          Image.asset('assets/share.png',
                                              width: 36, height: 36),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('好大的雪❄️，下到凌晨三点才停啊啊啊啊啊',
                                        style:
                                            Theme.of(context).textTheme.body1),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('共 5 张',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle
                                                .copyWith(fontSize: 12)),
                                        ButtonTheme(
                                          minWidth: 40,
                                          child: FlatButton(
                                              child: Text(
                                                '分享',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body1
                                                    .copyWith(fontSize: 12),
                                              ),
                                              onPressed: () {
                                                _share(_items[index].pics);
                                              }),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                              ]),
                        ]));
                  },
                ))),
        Positioned(
            left: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              width: MediaQuery.of(context).size.width,
              height: 42 + MediaQuery.of(context).padding.top,
              decoration:
                  BoxDecoration(color: Color.fromARGB(alpha, 237, 237, 237)),
              child: Row(children: [
                Icon(
                  Icons.navigate_before,
                  color: Colors.white,
                  size: 40,
                )
              ]),
            ))
      ]),
    ));
  }
}