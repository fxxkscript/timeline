import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wshop/api/feeds.dart';
import 'package:wshop/components/FeedImage.dart';
import 'package:wshop/models/auth.dart';
import 'package:wshop/models/feeds.dart';
import 'package:wshop/screens/editor.dart';
import 'package:wshop/screens/user.dart';

class TimelineTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimelineTabState();
  }
}

class TimelineTabState extends State<TimelineTab> {
  static const channel = const MethodChannel('com.meizizi.doraemon/door');
  Feeds feeds;
  int showHeaderBg = 0;
  bool isLoading = false;
  final PublishSubject<int> subject = PublishSubject<int>();

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

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  Future<List> _getList() async {
    if (feeds != null && !feeds.hasNext) {
      return feeds.list;
    }

    int cursor = feeds != null ? feeds.nextCursor : 0;

    feeds = await getTimeline(context, cursor);
    print(feeds);
    return feeds.list;
  }

  Future<void> _refresh() {
    feeds = null;
    return _getList();
  }

  Widget _itemBuilder(context, entry, index) {
    if (index == 0) {
      return Container(
        height: 270,
        child: Stack(children: [
          Image.asset('assets/bg.png'),
          Positioned(
            bottom: 55,
            right: 10,
            child: ClipRRect(
              child: Image.network(Auth().avatar,
                  width: 50, height: 50, fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          Positioned(
            bottom: 70,
            right: 100,
            child: Text(Auth().nickname,
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(color: Colors.white)),
          )
        ]),
      );
    }
    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(236, 236, 236, 1), width: 1.0))),
        padding: EdgeInsets.only(bottom: 10, right: 20),
        margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: Stack(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: ClipRRect(
                  child: Image.network(entry.author.avatar,
                      width: 42, height: 42, fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return UserScreen(author: entry.author);
                }));
              },
            ),
            Expanded(
                child: Column(
              children: <Widget>[
                Text(entry.author.nickname,
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(entry.content, style: Theme.of(context).textTheme.body1),
                FeedImage(
                  imageList: entry.pics,
                ),
                Text(entry.createdAt ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(fontSize: 12)),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            )),
          ]),
          Positioned(
              bottom: -17,
              right: 70,
              child: Row(children: [
                CupertinoButton(
                    child: entry.isZan
                        ? Image.asset('assets/stared.png',
                            width: 22, height: 22)
                        : Image.asset('assets/star.png', width: 22, height: 22),
                    onPressed: () async {
                      if (!entry.isZan) {
                        setState(() {
                          entry.isZan = true;
                          entry.star++;
                        });
                        await star(context, entry);
                      }
                    }),
                Text(
                  entry.star.toString(),
                  style: Theme.of(context).textTheme.subtitle,
                )
              ])),
          Positioned(
              bottom: -17,
              right: 0,
              child: CupertinoButton(
                  child: Image.asset('assets/share.png', width: 22, height: 22),
                  onPressed: () {
                    _share(entry.pics);
                  })),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
          displacement: 80,
          onRefresh: () => _refresh(),
          child: CustomScrollView(slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              brightness: Brightness.light,
              title: Text('动态'),
              actions: [
                ButtonTheme(
                  minWidth: 60,
                  height: 30,
                  child: Container(
                      margin: EdgeInsets.only(right: 16),
                      child: CupertinoButton(
                        child: Icon(Icons.photo_camera),
                        padding: EdgeInsets.only(bottom: 0),
                        onPressed: () async {
                          String result = await Navigator.of(context).push(
                              CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  title: '新建',
                                  builder: (BuildContext context) => Editor()));

                          if (result == 'save') {
                            _refresh();
                          }
                        },
                      )),
                )
              ],
              snap: true,
              floating: true,
            ),
            PagewiseSliverList(
                pageSize: 10,
                itemBuilder: _itemBuilder,
                pageFuture: (pageIndex) {
                  // return a Future that resolves to a list containing the page's data
                  return _getList();
                })
          ])),
    );
  }
}
