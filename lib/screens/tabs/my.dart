import 'package:flutter/material.dart';
import 'package:wshop/models/auth.dart';

class MyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: Container(
              color: Color.fromARGB(255, 237, 237, 237),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 266,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(top: 50, left: 24, right: 26),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: ClipRRect(
                                      child: Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 248, 248, 248)),
                                        child: Image.network(
                                          Auth().avatar,
                                          width: 64,
                                          height: 64,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed('/settings/profile');
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            Auth().nickname,
                                            style: Theme.of(context)
                                                .textTheme
                                                .title,
                                          ),
                                          Text(
                                            '查看并编辑个人资料',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle
                                                .copyWith(fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Image.asset(
                                      'assets/qrcode.png',
                                      width: 32,
                                      height: 32,
                                    ),
                                    onTap: () {},
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text('13',
                                          style: Theme.of(context)
                                              .textTheme
                                              .title
                                              .copyWith(fontSize: 16)),
                                      Text('动态',
                                          style: Theme.of(context)
                                              .textTheme
                                              .title
                                              .copyWith(fontSize: 12))
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text('13',
                                          style: Theme.of(context)
                                              .textTheme
                                              .title
                                              .copyWith(fontSize: 16)),
                                      Text('关注',
                                          style: Theme.of(context)
                                              .textTheme
                                              .title
                                              .copyWith(fontSize: 12))
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text('13',
                                          style: Theme.of(context)
                                              .textTheme
                                              .title
                                              .copyWith(fontSize: 16)),
                                      Text('粉丝',
                                          style: Theme.of(context)
                                              .textTheme
                                              .title
                                              .copyWith(fontSize: 12))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: GestureDetector(
                                child: Image.asset(
                                  'assets/banner.png',
                                  width: 343,
                                  height: 52,
                                ),
                                onTap: () {},
                              ),
                            )
                          ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 68,
                                margin: EdgeInsets.only(left: 16, right: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 16, right: 14),
                                        child: Image.asset(
                                          'assets/invite.png',
                                          width: 24,
                                          height: 24,
                                        )),
                                    Expanded(
                                      child: Text(
                                        '邀请好友',
                                        style:
                                            Theme.of(context).textTheme.body1,
                                      ),
                                    ),
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '邀请有奖',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1,
                                            ),
                                            Text('累计邀请66人',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle
                                                    .copyWith(fontSize: 12))
                                          ],
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Color.fromARGB(
                                              255, 209, 209, 214),
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                              )),
                          GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 68,
                                margin: EdgeInsets.only(left: 16, right: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 16, right: 14),
                                        child: Image.asset(
                                          'assets/money.png',
                                          width: 24,
                                          height: 24,
                                        )),
                                    Expanded(
                                      child: Text(
                                        '提现与反佣',
                                        style:
                                            Theme.of(context).textTheme.body1,
                                      ),
                                    ),
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '¥10.50 可提现',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1,
                                            ),
                                            Text('已提现¥8923.00',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle
                                                    .copyWith(fontSize: 12))
                                          ],
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Color.fromARGB(
                                              255, 209, 209, 214),
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 68,
                                margin: EdgeInsets.only(left: 16, right: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 16, right: 14),
                                        child: Image.asset(
                                          'assets/contact.png',
                                          width: 24,
                                          height: 24,
                                        )),
                                    Expanded(
                                      child: Text(
                                        '咨询客服',
                                        style:
                                            Theme.of(context).textTheme.body1,
                                      ),
                                    ),
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.chevron_right,
                                          color: Color.fromARGB(
                                              255, 209, 209, 214),
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                              )),
                          GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 68,
                                margin: EdgeInsets.only(left: 16, right: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 16, right: 14),
                                        child: Image.asset(
                                          'assets/setting.png',
                                          width: 24,
                                          height: 24,
                                        )),
                                    Expanded(
                                      child: Text(
                                        '设置',
                                        style:
                                            Theme.of(context).textTheme.body1,
                                      ),
                                    ),
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.chevron_right,
                                          color: Color.fromARGB(
                                              255, 209, 209, 214),
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    ));
  }
}
