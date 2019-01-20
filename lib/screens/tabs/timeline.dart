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
        )
      ),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            // contentPadding: EdgeInsets.all(0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black, width: 1.0))
                  ),
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(
                        'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover
                      ),
                      Column(
                        children: <Widget>[
                          Text("美女名字"),
                          Text("哔哔哔一堆废话"),
                          Row(children: <Widget>[
                            Image.network(
                              'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover
                            ),
                            Image.network(
                              'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover
                            ),
                          ]),
                          Text('9分钟前'),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      )
                    ]
                  )
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: RaisedButton(
                    child: Text('分享到朋友圈'),
                    onPressed: () { _share(); }
                  )
                )
              ]
            )
          );
        },
      ),
    );
  }


}