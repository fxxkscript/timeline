import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wshop/api/feeds.dart';
import 'package:wshop/components/FeedImage.dart';
import 'package:wshop/models/feeds.dart';
import 'package:wshop/screens/editor.dart';

class TimelineTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimelineTabState();
  }
}

class TimelineTabState extends State<TimelineTab> {
  static const channel = const MethodChannel('com.meizizi.doraemon/share');

  final List<Feed> items = [];

  Future<void> _share() async {
    try {
      final int result = await channel.invokeMethod('weixin', [
        "https://ws3.sinaimg.cn/large/006tNc79gy1fyworuc0v0j3020020mx1.jpg",
        "https://ws3.sinaimg.cn/large/006tNc79gy1fywpblwgk4j3020020glf.jpg"
      ]);
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

  void _getList() async {
    await publish(
        context,
        Feed(
            'hahaha',
            [
              'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552121753&di=1794dc32aedaad9a9fcc8c83957e1524&imgtype=jpg&er=1&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F15%2F68%2F59%2F71X58PICNjx_1024.jpg',
              'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
            ],
            '',
            0));

    await getTimeline(context, 0);

    print(11111);
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552121753&di=1794dc32aedaad9a9fcc8c83957e1524&imgtype=jpg&er=1&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F15%2F68%2F59%2F71X58PICNjx_1024.jpg',
      'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
    ];

    return Container(
      child: Stack(children: [
        RefreshIndicator(
            displacement: 80,
            onRefresh: () {},
            child: ListView.builder(
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    height: 300,
                    child: Stack(children: [
                      Image.asset('assets/bg.png'),
                      Positioned(
                        bottom: 55,
                        right: 10,
                        child: ClipRRect(
                          child: Image.network(
                              'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      Positioned(
                        bottom: 70,
                        right: 100,
                        child: Text('威武的✈️',
                            style: Theme.of(context)
                                .textTheme
                                .headline
                                .copyWith(color: Colors.white)),
                      )
                    ]),
                  );
                }
                index = index - 1;
                return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color.fromRGBO(236, 236, 236, 1),
                                width: 1.0))),
                    padding: EdgeInsets.only(bottom: 10, right: 20),
                    margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: Stack(children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                child: Image.network(
                                    'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                                    width: 42,
                                    height: 42,
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Text('美女名字',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        decoration: TextDecoration.none)),
                                Text(
                                    '哔哔哔一堆废话,哔哔哔一堆废话哔哔哔一堆废话哔哔哔一堆废话哔哔哔一堆废话哔哔哔一堆废话哔哔哔一堆废话',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        decoration: TextDecoration.none)),
                                FeedImage(
                                  imageList: imageList,
                                ),
                                Text('9分钟前',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black38,
                                        decoration: TextDecoration.none)),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            )),
                          ]),
                      Positioned(
                          bottom: -17,
                          right: 0,
                          child: CupertinoButton(
                              child: Image.asset('assets/share.png',
                                  width: 22, height: 22),
                              onPressed: () {
                                _share();
                              })),
                      Positioned(
                          bottom: -15,
                          right: 70,
                          child: FlatButton.icon(
                              icon: Icon(Icons.favorite_border,
                                  color: Colors.grey),
                              label: Text('100',
                                  style: TextStyle(color: Colors.grey)),
                              onPressed: () {
                                _share();
                              })),
                    ]));
              },
            )),
        Positioned(
          child: CupertinoNavigationBar(
              middle: Text('动态'),
              trailing: CupertinoButton(
                child: Icon(Icons.photo_camera),
                padding: EdgeInsets.only(bottom: 0),
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      fullscreenDialog: true,
                      title: '新建',
                      builder: (BuildContext context) => Editor()));
                },
              )),
        )
      ]),
    );
  }
}
