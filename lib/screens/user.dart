import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wshop/api/feeds.dart';
import 'package:wshop/api/friends.dart';
import 'package:wshop/api/profile.dart';
import 'package:wshop/components/FeedImage.dart';
import 'package:wshop/components/FollowBtn.dart';
import 'package:wshop/models/auth.dart';
import 'package:wshop/models/author.dart';
import 'package:wshop/models/feeds.dart';
import 'package:wshop/models/profile.dart';
import 'package:wshop/utils/share.dart';

class UserScreen extends StatefulWidget {
  final Author author;

  UserScreen({Key key, @required this.author});

  @override
  State<StatefulWidget> createState() {
    return UserScreenState();
  }
}

class UserScreenState extends State<UserScreen> {
  List<Feed> _items = [];
  Feeds feeds;
  int alpha = 0;
  TimelineProfile _timelineProfile =
      TimelineProfile(author: Author(0, '', ''), signature: '');

  @override
  void initState() {
    super.initState();

    _getList();
    _getProfile();
  }

  Future<void> _getProfile() async {
    var tmp = await getTimelineProfile(widget.author.uid);
    setState(() {
      _timelineProfile = tmp;
    });
  }

  Future<void> _getList() async {
    if (feeds != null && !feeds.hasNext) {
      return;
    }
    int cursor = feeds != null ? feeds.nextCursor : 0;

    try {
      feeds = await getUserFeeds(widget.author.uid, cursor);
      setState(() {
        _items.addAll(feeds.list);
      });
    } catch (e) {
      print(e);
    }
  }

  Widget header() {
    var arr = [
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
          child: Image.network(_timelineProfile.author.avatar,
              width: 64, height: 64, fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      Positioned(
        left: 92,
        top: 101,
        child: Text(widget.author.nickname,
            style: Theme.of(context)
                .textTheme
                .headline
                .copyWith(color: Colors.white)),
      ),
      Positioned(
        left: 92,
        top: 129,
        child: Text(_timelineProfile.signature,
            style: Theme.of(context)
                .textTheme
                .headline
                .copyWith(color: Colors.white, fontSize: 12)),
      ),
      Positioned(
        left: 92,
        top: 166,
        child: Text(
            '上新 ${_timelineProfile.news}                总数 ${_timelineProfile.tweets}',
            style: Theme.of(context)
                .textTheme
                .headline
                .copyWith(color: Colors.white, fontSize: 12)),
      )
    ];

    if (_timelineProfile.author.uid != Auth().uid) {
      arr.add(Positioned(
          right: 12,
          top: 108,
          child: FollowBtn(
            isFollowed: _timelineProfile.isFriend ?? false,
            onPressed: (bool isFollowed) async {
              if (isFollowed) {
                await cancelFriend(id: _timelineProfile.author.uid);
              } else {
                await addFriend(id: _timelineProfile.author.uid);
              }
              await _getProfile();
            },
          )));
    }

    return Container(
      height: 300,
      child: Stack(children: arr),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(children: [
        NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              print(scrollInfo);
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
                  scrollInfo.metrics.maxScrollExtent - 300) {
                _getList();
              }
              return true;
            },
            child: RefreshIndicator(
                displacement: 80,
                onRefresh: () {
                  setState(() {
                    _items.clear();
                    feeds = null;
                  });
                  return _getList();
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: _items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return header();
                    }
                    index = index - 1;
                    DateTime time = DateTime.parse(_items[index].createdAt);
                    bool showTime = true;
                    if (index > 0) {
                      DateTime preTime =
                          DateTime.parse(_items[index - 1].createdAt);

                      if (preTime.day == time.day &&
                          preTime.month == time.month &&
                          preTime.year == time.year) {
                        showTime = false;
                      }
                    }

                    List<Widget> widgets = showTime
                        ? <Widget>[
                            Container(
                              width: 80,
                              height: 100,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Text('${time.day}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .title
                                            .copyWith(fontSize: 30)),
                                  ),
                                  Positioned(
                                      left: 40,
                                      top: 16,
                                      child: Text('${time.month}月',
                                          style: Theme.of(context)
                                              .textTheme
                                              .title
                                              .copyWith(fontSize: 12))),
                                ],
                              ),
                            ),
                          ]
                        : <Widget>[
                            SizedBox(
                              width: 80,
                              height: 100,
                            )
                          ];
                    if (_items[index].pics.length > 0) {
                      widgets.add(Container(
                          width: 74,
                          height: 74,
                          margin: EdgeInsets.only(right: 10),
                          child: FeedImage(
                              type: FeedImageType.multiple,
                              imageList: _items[index].pics)));
                    }

                    List<Widget> infos = [
                      SelectableText(_items[index].content,
                          style: Theme.of(context).textTheme.body1)
                    ];

                    if (_items[index].pics.length > 0) {
                      infos.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('共 ${_items[index].pics.length} 张',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle
                                    .copyWith(fontSize: 12)),
                            CupertinoButton(
                                child: Image.asset('assets/share.png',
                                    width: 22, height: 22),
                                onPressed: () {
                                  Share().share(
                                      context: context,
                                      feed: _items[index],
                                      block: () {
                                        block(_items[index]);
                                        setState(() {
                                          _items.removeAt(index);
                                        });
                                      },
                                      delete: () {
                                        delete(_items[index]);
                                        setState(() {
                                          _items.removeAt(index);
                                        });
                                      });
                                })
                          ]));
                    } else {
                      infos.add(Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CupertinoButton(
                                child: Image.asset('assets/share.png',
                                    width: 22, height: 22),
                                onPressed: () {
                                  Share().share(
                                      context: context,
                                      feed: _items[index],
                                      block: () {
                                        block(_items[index]);
                                        setState(() {
                                          _items.removeAt(index);
                                        });
                                      },
                                      delete: () {
                                        delete(_items[index]);
                                        setState(() {
                                          _items.removeAt(index);
                                        });
                                      });
                                })
                          ]));
                    }

                    widgets.add(Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: infos,
                    )));

                    return Container(
                        decoration: BoxDecoration(),
                        padding: EdgeInsets.only(bottom: 10, right: 20),
                        margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widgets));
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
                GestureDetector(
                  child: Icon(
                    Icons.navigate_before,
                    color: Colors.white,
                    size: 40,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                )
              ]),
            ))
      ]),
    ));
  }
}
