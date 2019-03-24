import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wshop/api/friends.dart';
import 'package:wshop/components/FollowBtn.dart';
import 'package:wshop/models/auth.dart';
import 'package:wshop/models/author.dart';

class Contacts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactsState();
  }
}

class ContactsState extends State<Contacts> {
  List<Author> list = [];
  int count = 0;
  int fansCount = 0;

  @override
  void initState() {
    super.initState();

    _getData();
  }

  Future _getData() async {
    Map<String, dynamic> data = await findFriend(context: context);
    Map<String, dynamic> followerData = await findFollower(context: context);

    setState(() {
      list = data['list'];
      count = data['count'];
      fansCount = followerData['count'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('关注'),
        ),
        child: RefreshIndicator(
            displacement: 80,
            child: ListView.builder(
                itemCount: count,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        margin: EdgeInsets.only(top: 10, bottom: 10),
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
                                    Auth().avatar,
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
                                    '我的粉丝',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    fansCount.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle
                                        .copyWith(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Color.fromARGB(255, 209, 209, 214),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/friends/fans');
                      },
                    );
                  }

                  index = index - 1;

                  return Container(
                    decoration: BoxDecoration(color: Colors.white),
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
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
                                  color: Color.fromARGB(255, 248, 248, 248)),
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
                              Text(
                                '上新12 共110',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle
                                    .copyWith(fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        FollowBtn(
                          isFollowed: true,
                          onPressed: (bool isFollowed) async {
                            if (isFollowed) {
                              await cancelFriend(
                                  context: context, id: list[index].uid);
                            } else {
                              await addFriend(
                                  context: context, id: list[index].uid);
                            }
                            _getData();
                          },
                        )
                      ],
                    ),
                  );
                }),
            onRefresh: () => _getData()));
    ;
  }
}
