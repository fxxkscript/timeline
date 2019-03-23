import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wshop/models/auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
      child: Stack(children: [
        ListView(
          padding: EdgeInsets.only(top: 0),
          children: <Widget>[
            Container(
              height: 236,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bg.png'), fit: BoxFit.cover)),
              child: Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        child: Image.network(Auth().avatar,
                            width: 70, height: 70, fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(Auth().nickname,
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(fontSize: 18)),
                      ),
                    ],
                  )),
            ),
            Container(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          padding: EdgeInsets.only(left: 16),
                          height: 56,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.5,
                                        color:
                                            Theme.of(context).dividerColor))),
                            padding: EdgeInsets.only(right: 16),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '手机号',
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    textAlign: TextAlign.right,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(11)
                                    ],
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '填写手机号'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return '请填写手机号';
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          padding: EdgeInsets.only(left: 16),
                          height: 56,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.5,
                                        color:
                                            Theme.of(context).dividerColor))),
                            padding: EdgeInsets.only(right: 16),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '微信号',
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '填写微信号'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return '请填写微信号';
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          padding: EdgeInsets.only(left: 16),
                          height: 56,
                          child: Container(
                            padding: EdgeInsets.only(right: 16),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '微信二维码',
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                ),
                                Expanded(
                                  child: Text(
                                    '点击上传',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(left: 16, top: 20),
                          height: 112,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.5,
                                        color:
                                            Theme.of(context).dividerColor))),
                            padding: EdgeInsets.only(right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '微信号',
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '填写微信号'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return '请填写微信号';
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))),
          ],
        ),
        Positioned(
            left: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              width: MediaQuery.of(context).size.width,
              height: 42 + MediaQuery.of(context).padding.top,
              decoration:
                  BoxDecoration(color: Color.fromARGB(0, 237, 237, 237)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.navigate_before,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text('个人资料',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 17)),
                  ),
                  Expanded(
                    flex: 1,
                    child: ButtonTheme(
                        minWidth: 60,
                        height: 30,
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          child: const Text(
                            '完成',
                            style: TextStyle(color: Colors.white),
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                        )),
                  )
                ],
              ),
            ))
      ]),
    ));
  }
}
