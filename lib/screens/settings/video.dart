import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wshop/components/Back.dart';

class Video extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VideoState();
  }
}

class VideoState extends State<Video> {
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
                        arguments: {'url': 'https://youku.com'});
                  },
                  child: Container(
                    height: 68,
                    margin: EdgeInsets.only(left: 16, right: 18),
                    child: Container(
                        margin: EdgeInsets.only(left: 16, right: 14),
                        child: Image.asset(
                          'assets/iqiyi.png',
                          width: 24,
                          height: 24,
                        )),
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/freeVideo',
                        arguments: {'url': 'https://iqiyi.com'});
                  },
                  child: Container(
                    height: 68,
                    margin: EdgeInsets.only(left: 16, right: 18),
                    child: Container(
                        margin: EdgeInsets.only(left: 16, right: 14),
                        child: Image.asset(
                          'assets/iqiyi.png',
                          width: 24,
                          height: 24,
                        )),
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/freeVideo',
                        arguments: {'url': 'https://v.qq.com/'});
                  },
                  child: Container(
                    height: 68,
                    margin: EdgeInsets.only(left: 16, right: 18),
                    child: Container(
                        margin: EdgeInsets.only(left: 16, right: 14),
                        child: Image.asset(
                          'assets/iqiyi.png',
                          width: 24,
                          height: 24,
                        )),
                  )),
            ],
          ),
        ));
  }
}
