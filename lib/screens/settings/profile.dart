import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:wshop/models/profile.dart';
import 'package:wshop/api/profile.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:wshop/api/qiniu.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class _ProfileData {
  String mobile;
  String wechatQrCode;
  String wechatId;
  String signature;

  Map<String, String> toMap() {
    return {
      'mobile': mobile,
      'wechatQrCode': wechatQrCode,
      'wechatId': wechatId,
      'signature': signature
    };
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  _ProfileData _data = new _ProfileData();

  @override
  void initState() {
    super.initState();
  }

  void selectQrCode() async {
    List<Asset> resultList = [];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
      );
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(title: Text(e.message)));
    }

    if (!mounted) return;

    setState(() async {
      ByteData byteData = await resultList[0].requestOriginal();
      Uint8List imageData = byteData.buffer.asUint8List();
      Uint8List imageDataCompressed = Uint8List.fromList(
          await FlutterImageCompress.compressWithList(imageData));
      _data.wechatQrCode = await Qiniu.upload(context, imageDataCompressed);
    });
  }

  void save(context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final bool result = await saveProfile(context, _data.toMap());

      final snackBar = SnackBar(
        content: Text(result ? '保存成功' : '保存失败', textAlign: TextAlign.center),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Profile>(
        future: fetchProfile(context),
        builder: (context, snapshot) {
          final Scaffold scaffold = Scaffold(
              body: Builder(
                  builder: (context) => snapshot.hasData
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          ClipRRect(
                                            child: Image.network(
                                                snapshot.data.user.avatar,
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(35),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                                snapshot.data.user.nickname,
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
                                              padding:
                                                  EdgeInsets.only(left: 16),
                                              height: 56,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 0.5,
                                                            color: Theme.of(
                                                                    context)
                                                                .dividerColor))),
                                                padding:
                                                    EdgeInsets.only(right: 16),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      '手机号',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .title
                                                          .copyWith(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                    Expanded(
                                                      child: TextFormField(
                                                          initialValue: snapshot
                                                              .data.user.mobile,
                                                          keyboardType:
                                                              TextInputType
                                                                  .phone,
                                                          textAlign:
                                                              TextAlign.right,
                                                          inputFormatters: [
                                                            LengthLimitingTextInputFormatter(
                                                                11)
                                                          ],
                                                          onSaved:
                                                              (String value) {
                                                            _data.mobile =
                                                                value;
                                                          },
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
                                              padding:
                                                  EdgeInsets.only(left: 16),
                                              height: 56,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 0.5,
                                                            color: Theme.of(
                                                                    context)
                                                                .dividerColor))),
                                                padding:
                                                    EdgeInsets.only(right: 16),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      '微信号',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .title
                                                          .copyWith(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                    Expanded(
                                                      child: TextFormField(
                                                          initialValue: snapshot
                                                              .data
                                                              .detail
                                                              .wechatId,
                                                          onSaved:
                                                              (String value) {
                                                            _data.wechatId =
                                                                value;
                                                          },
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
                                              padding:
                                                  EdgeInsets.only(left: 16),
                                              height: 56,
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(right: 16),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      '微信二维码',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .title
                                                          .copyWith(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                    CupertinoButton(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: Text('点击上传',
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontSize: 16)),
                                                      onPressed: selectQrCode,
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
                                                            color: Theme.of(
                                                                    context)
                                                                .dividerColor))),
                                                padding:
                                                    EdgeInsets.only(right: 16),
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                    Expanded(
                                                      child: TextFormField(
                                                          initialValue: snapshot
                                                              .data
                                                              .detail
                                                              .signature,
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.left,
                                                          inputFormatters: [
                                                            LengthLimitingTextInputFormatter(
                                                                30)
                                                          ],
                                                          onSaved:
                                                              (String value) {
                                                            _data.signature =
                                                                value;
                                                          },
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
                                  height:
                                      42 + MediaQuery.of(context).padding.top,
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
                                            color: Theme.of(context)
                                                .primaryColorDark,
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
                                              margin:
                                                  EdgeInsets.only(right: 16),
                                              child: FlatButton(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                child: const Text(
                                                  '完成',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  this.save(context);
                                                },
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ))
                          ]),
                        )
                      : Center(child: new CircularProgressIndicator())));
          return scaffold;
        });
  }
}
