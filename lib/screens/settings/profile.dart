import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:wshop/models/profile.dart';
import 'package:wshop/api/profile.dart';

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

  Future uploadImage() async {
    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: false,
      );
    } catch (e) {
//      error = e.message;
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Profile>(
        future: fetchProfile(context),
        builder: (context, snapshot) {
          final Scaffold scaffold = Scaffold(
              body: snapshot.hasData
                  ? Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor),
                      child: Stack(children: [
                        ListView(
                          padding: EdgeInsets.only(top: 0),
                          children: <Widget>[
                            Container(
                              height: 236,
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                  margin: EdgeInsets.only(top: 40),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ClipRRect(
                                        child: Image.network(snapshot.data.avatar,
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(snapshot.data.nickname,
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
                                          decoration: BoxDecoration(
                                              color: Colors.white),
                                          padding: EdgeInsets.only(left: 16),
                                          height: 56,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 0.5,
                                                        color: Theme.of(context)
                                                            .dividerColor))),
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
                                                          fontWeight: FontWeight
                                                              .normal),
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                      initialValue: snapshot
                                                          .data.mobile,
                                                      keyboardType:
                                                          TextInputType.phone,
                                                      textAlign:
                                                          TextAlign.right,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            11)
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  '填写手机号')),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white),
                                          padding: EdgeInsets.only(left: 16),
                                          height: 56,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 0.5,
                                                        color: Theme.of(context)
                                                            .dividerColor))),
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
                                                          fontWeight: FontWeight
                                                              .normal),
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                      textAlign:
                                                          TextAlign.right,
                                                      decoration:
                                                          InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  '填写微信号')),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white),
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
                                                          fontWeight: FontWeight
                                                              .normal),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '点击上传',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 16),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white),
                                          margin: EdgeInsets.only(top: 10),
                                          padding: EdgeInsets.only(
                                              left: 16, top: 20),
                                          height: 112,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 0.5,
                                                        color: Theme.of(context)
                                                            .dividerColor))),
                                            padding: EdgeInsets.only(right: 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '个人签名',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .title
                                                      .copyWith(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                      maxLines: 2,
                                                      textAlign: TextAlign.left,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            30)
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  '填写个人签名')),
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
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top),
                              width: MediaQuery.of(context).size.width,
                              height: 42 + MediaQuery.of(context).padding.top,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(0, 237, 237, 237)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Icon(
                                        Icons.navigate_before,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
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
                                        child: Container(
                                          margin: EdgeInsets.only(right: 16),
                                          child: FlatButton(
                                            color:
                                                Theme.of(context).primaryColor,
                                            child: const Text(
                                              '完成',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                print(context);
                                              }
                                            },
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ))
                      ]),
                    )
                  : Center(child: new CircularProgressIndicator()));
          return scaffold;
        });
  }
}
