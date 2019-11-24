import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wshop/api/friends.dart';
import 'package:wshop/components/Back.dart';
import 'package:wshop/components/FollowBtn.dart';
import 'package:wshop/models/follower.dart';

class FansScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FansScreenState();
  }
}

class FansScreenState extends State<FansScreen> {
  List<Follower> list = [];

  @override
  void initState() {
    super.initState();

    _getData();
  }

  Future _getData() async {
    Map<String, dynamic> data = await findFollower();

    setState(() {
      list = data['list'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: Back(
            color: Theme.of(context).primaryColorDark,
          ),
          middle: Text('我的粉丝'),
        ),
        child: RefreshIndicator(
            displacement: 80,
            child: list.length == 0
                ? Center(
                    child: Text(
                    '没有数据',
                    style: Theme.of(context).textTheme.body1,
                  ))
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(color: Colors.white),
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                      color:
                                          Color.fromARGB(255, 248, 248, 248)),
                                  child: Image.network(
                                    list[index].avatar,
                                    width: 56,
                                    height: 56,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    list[index].nickname,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  // TODO 上新数据
                                  Text(
                                    '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle
                                        .copyWith(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                            FollowBtn(
                              isFollowed: list[index].isFriend,
                              onPressed: (bool isFollowed) async {
                                if (isFollowed) {
                                  await cancelFriend(id: list[index].uid);
                                } else {
                                  await addFriend(id: list[index].uid);
                                }
                                _getData();
                              },
                            )
                          ],
                        ),
                      );
                    }),
            onRefresh: () => _getData()));
  }
}
