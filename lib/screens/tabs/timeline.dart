import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wshop/screens/editor.dart';

class TimelineTab extends StatelessWidget {
  static const channel = const MethodChannel('com.meizizi.doraemon/share');

  final items = List<String>.generate(1000, (i) => "Item $i");

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
  Widget build(BuildContext context) {
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
                                Container(
                                    margin: EdgeInsets.only(
                                        right: 10, bottom: 10, top: 10),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: <Widget>[
                                        Image.network(
                                            'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover),
                                        Image.network(
                                            'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover),
                                        Image.network(
                                            'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover),
                                        Image.network(
                                            'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover),
                                      ],
                                    )),
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
