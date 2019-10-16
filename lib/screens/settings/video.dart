import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wshop/components/Back.dart';

class VideoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VideoScreenState();
  }
}

class VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: Back(
            color: Theme.of(context).primaryColorDark,
          ),
          middle: Text('免费看VIP视频'),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 80),
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20.0),
            crossAxisSpacing: 10.0,
            crossAxisCount: 3,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/freeVideo',
                        arguments: {'url': 'https://youku.com', 'title': '优酷'});
                  },
                  child: Container(
                    height: 68,
                    margin: EdgeInsets.only(left: 16, right: 18),
                    child: Container(
                        margin: EdgeInsets.only(left: 16, right: 14),
                        child: Image.asset(
                          'assets/yk.jpg',
                          width: 24,
                          height: 24,
                        )),
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/freeVideo', arguments: {
                      'url': 'https://m.iqiyi.com',
                      'title': '爱奇艺'
                    });
                  },
                  child: Container(
                    height: 68,
                    margin: EdgeInsets.only(left: 16, right: 18),
                    child: Container(
                        margin: EdgeInsets.only(left: 16, right: 14),
                        child: Image.asset(
                          'assets/aqy.jpg',
                          width: 24,
                          height: 24,
                        )),
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/freeVideo', arguments: {
                      'url': 'http://m.v.qq.com',
                      'title': '腾讯视频'
                    });
                  },
                  child: Container(
                    height: 68,
                    margin: EdgeInsets.only(left: 16, right: 18),
                    child: Container(
                        margin: EdgeInsets.only(left: 16, right: 14),
                        child: Image.asset(
                          'assets/tx.jpg',
                          width: 24,
                          height: 24,
                        )),
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/freeVideo', arguments: {
                      'url': 'https://m.mgtv.com',
                      'title': '芒果'
                    });
                  },
                  child: Container(
                    height: 68,
                    margin: EdgeInsets.only(left: 16, right: 18),
                    child: Container(
                        margin: EdgeInsets.only(left: 16, right: 14),
                        child: Image.asset(
                          'assets/mg.jpg',
                          width: 24,
                          height: 24,
                        )),
                  )),
            ],
          ),
        ));
  }
}
