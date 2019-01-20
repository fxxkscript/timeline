import 'dart:async';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimelineTab extends StatelessWidget {
  static const channel = const MethodChannel('com.tomo.wshop/share');

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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: Text('相册'),
          trailing: CupertinoButton(
            child: Icon(Icons.add_circle_outline),
            padding: EdgeInsets.only(bottom: 0),
            onPressed: () {},
          )),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
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
                        child: Image.network(
                            'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover),
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
                        child: Icon(Icons.more, color: Colors.grey),
                        onPressed: () {
                          _share();
                        }))
              ]));
        },
      ),
    );
  }
}
