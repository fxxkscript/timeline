import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wshop/api/feeds.dart';
import 'package:wshop/components/FeedImage.dart';
import 'package:wshop/components/TopBar.dart';
import 'package:wshop/models/auth.dart';
import 'package:wshop/models/feeds.dart';
import 'package:wshop/screens/user.dart';
import 'package:wshop/utils/share.dart';

class TimelineTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimelineTabState();
  }
}

class TimelineTabState extends State<TimelineTab> {
  List<Feed> _items = [];
  Feeds feeds;
  int showHeaderBg = 0;
  bool isLoading = false;
  final PublishSubject<int> subject = PublishSubject<int>();

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

  Future<void> _getList({bool refresh = false}) async {
    if (isLoading) {
      return;
    }
    isLoading = true;

    if (feeds != null && !feeds.hasNext && !refresh) {
      return;
    }
    int cursor;

    if (refresh) {
      cursor = 0;
    } else {
      cursor = feeds != null ? feeds.nextCursor : 0;
    }

    feeds = await getTimeline(cursor);

    setState(() {
      if (refresh) {
        _items.clear();
      }
      _items.addAll(feeds.list);
    });

    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        RefreshIndicator(
            displacement: 80,
            onRefresh: () {
              return _getList(refresh: true);
            },
            child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >
                      scrollInfo.metrics.maxScrollExtent - 300) {
                    _getList();
                  }

                  if (scrollInfo.metrics.pixels < 0) {
                    subject.add(0);
                  } else if (scrollInfo.metrics.pixels > 0 &&
                      scrollInfo.metrics.pixels < 100) {
                    subject
                        .add((scrollInfo.metrics.pixels / 100 * 255).round());
                  } else if (scrollInfo.metrics.pixels > 0) {
                    subject.add(255);
                  }
                  return true;
                },
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 0, bottom: 100),
                  itemCount: _items.length + 1,
                  itemBuilder: (context, index) {
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
                                GestureDetector(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: ClipRRect(
                                      child: Image.network(
                                          _items[index].author.avatar,
                                          width: 42,
                                          height: 42,
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return UserScreen(
                                          author: _items[index].author);
                                    }));
                                  },
                                ),
                                Expanded(
                                    child: Column(
                                  children: <Widget>[
                                    Text(_items[index].author.nickname,
                                        style: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .copyWith(
                                                fontWeight: FontWeight.w600)),
                                    Text(_items[index].content,
                                        style:
                                            Theme.of(context).textTheme.body1),
                                    FeedImage(
                                      imageList: _items[index].pics,
                                    ),
                                    Text(_items[index].createdAt ?? '',
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
                                    child: _items[index].isZan
                                        ? Image.asset('assets/stared.png',
                                            width: 22, height: 22)
                                        : Image.asset('assets/star.png',
                                            width: 22, height: 22),
                                    onPressed: () async {
                                      if (!_items[index].isZan) {
                                        setState(() {
                                          _items[index].isZan = true;
                                          _items[index].star++;
                                        });
                                        await star(_items[index]);
                                      }
                                    }),
                                Text(
                                  _items[index].star.toString(),
                                  style: Theme.of(context).textTheme.subtitle,
                                )
                              ])),
                          Positioned(
                              bottom: -17,
                              right: 0,
                              child: CupertinoButton(
                                  child: Image.asset('assets/share.png',
                                      width: 22, height: 22),
                                  onPressed: () {
                                    Share().share(
                                        context,
                                        _items[index].pics,
                                        _items[index].content,
                                        _items[index].id, () {
                                      _getList(refresh: true);
                                    });
                                  })),
                        ]));
                  },
                ))),
        Positioned(
            left: 0,
            top: 0,
            child: TopBar(
                subject: subject,
                refresh: () {
                  _getList(refresh: true);
                }))
      ]),
    );
  }
}
