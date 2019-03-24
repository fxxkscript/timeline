import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wshop/api/friends.dart';
import 'package:wshop/models/auth.dart';
import 'package:wshop/models/author.dart';

class FansScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FansScreenState();
  }
}

class FansScreenState extends State<FansScreen> {
  List<Author> list = [];
  int count = 0;

  @override
  void initState() {
    super.initState();

    _getData();
  }

  Future _getData() async {
    Map<String, dynamic> data = await findFollower(context: context);

    setState(() {
      list = data['list'];
      count = data['count'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('关注'),
        ),
        child: RefreshIndicator(
            child: ListView.builder(
                itemCount: count,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
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
                                    color: Color.fromARGB(255, 248, 248, 248)),
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
                                  '1280',
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
                        FlatButton(
                          onPressed: () {},
                          child: Container(
                            width: 90,
                            height: 27,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 12, 193, 96),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                                child: Text(
                              '关注',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            )),
                          ),
                        )
                      ],
                    ),
                  );
                }),
            onRefresh: () => _getData()));
    ;
  }
}
