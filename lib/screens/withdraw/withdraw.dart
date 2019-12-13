import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wshop/api/qiniu.dart';
import 'package:wshop/api/withdraw.dart';
import 'package:wshop/models/withdraw.dart';

import 'withdrawSuccess.dart';

class WithdrawScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WithdrawScreenState();
  }
}

class WithdrawScreenState extends State<WithdrawScreen> {
  Future<UserAsset> _fetchUserAsset;

  @override
  void initState() {
    super.initState();
    this._fetchUserAsset = fetchUserAsset();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserAsset>(
        future: _fetchUserAsset,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: new CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          } else {
            return buildScaffold(snapshot.data);
          }
        });
  }

  Widget buildScaffold(UserAsset userAsset) {
    return Scaffold(
        appBar: AppBar(
          title: Text('提现与返佣'),
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          actions: <Widget>[
            Center(
                child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                child: Text('资金明细'),
                onTap: () {
                  Navigator.pushNamed(context, '/fundFlow');
                },
              ),
            ))
          ],
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Container(
              height: 50.0,
            ),
            Image.asset(
              'assets/withdraw_icon.png',
              scale: 2,
            ),
            Container(
              height: 30.0,
            ),
            const Text('可提现金额'),
            Container(
              height: 20.0,
            ),
            DefaultTextStyle(
              style: TextStyle(
                  color: Color(0xFF131313), fontWeight: FontWeight.w600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  const Text('￥'),
                  Text(userAsset.availableAmount?.toStringAsFixed(2) ?? '',
                      style: TextStyle(
                        fontSize: 36,
                      ))
                ],
              ),
            ),
            Container(
              height: 90.0,
            ),
            Container(
              width: 160,
              child: FlatButton(
                child: const Text(
                  '提现',
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute<bool>(
                      fullscreenDialog: true,
                      builder: (BuildContext context) =>
                          WithdrawModal(userAsset),
                    ),
                  );
                },
              ),
            ),
            Container(height: 30),
            Text('已冻结¥${userAsset.frozenAmount?.toStringAsFixed(2) ?? ''}',
                style: TextStyle(color: Color(0xFFACACAC), fontSize: 14)),
            Container(height: 20),
            Text(
              '如何获取收益？',
              style: TextStyle(color: Color(0xFF536693), fontSize: 14),
            )
          ],
        ));
  }
}

class WithdrawModal extends StatefulWidget {
  final UserAsset userAsset;

  WithdrawModal(this.userAsset);

  @override
  State<StatefulWidget> createState() {
    return WithdrawModalState(userAsset);
  }
}

class WithdrawModalState extends State<WithdrawModal> {
  final UserAsset userAsset;
  final TextEditingController _inputController = new TextEditingController();
  String inputText = '';
  String qrcodeUrl = '';
  Uint8List _selectedImage;

  WithdrawModalState(this.userAsset);

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _inputController.addListener(() {
      setState(() {
        inputText = _inputController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('提现'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);
                });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTextStyle(
          style: TextStyle(fontSize: 14, color: Color(0xFF131313)),
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[modalHead(context), modalBody(context)],
            ),
          ),
        ),
      ),
    );
  }

  Widget modalHead(context) {
    return Container(
      color: Color(0xFFFBFBFB),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('提现至'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('微信钱包'),
                Container(height: 2),
                Text('24小时内到账',
                    style: TextStyle(fontSize: 12, color: Color(0xFFACACAC))),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget modalBody(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('提现金额'),
          TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              cursorColor: Theme.of(context).primaryColor,
              style: TextStyle(fontSize: 36),
              decoration: new InputDecoration(
                  border: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFE5E5E5), width: 0.5)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFE5E5E5), width: 0.5)),
                  prefixIcon: Text(
                    '￥',
                    style: TextStyle(fontSize: 36),
                  ))),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
                '共￥${userAsset.availableAmount?.toStringAsFixed(2) ?? ''}可提现',
                style: TextStyle(fontSize: 12, color: Color(0xFFACACAC))),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              child: Text('立即提现', style: TextStyle(color: Colors.white)),
              color: Theme.of(context).primaryColor,
              disabledColor: Color(0x880CC160),
              onPressed: inputText.isEmpty || qrcodeUrl.isEmpty
                  ? null
                  : () async {
                      try {
                        var result =
                            await withdrawMoney(context, inputText, qrcodeUrl);
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute<bool>(
                            fullscreenDialog: true,
                            builder: (BuildContext context) =>
                                WithdrawSuccessModal(userAsset,
                                    double.parse(_inputController.text)),
                          ),
                        );
                      } catch (e) {
                        showToast(e.toString(),
                            textPadding: EdgeInsets.all(15));
                      }
                    },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
                width: double.infinity,
                child: FlatButton(
                    child: const Text('上传收款二维码',
                        style: TextStyle(color: Colors.white)),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      selectQrCode();
                    })),
          ),
          Center(
            child: _selectedImage != null
                ? Image.memory(
                    _selectedImage,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                    width: 200,
                    height: 200,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  void selectQrCode() async {
    List<Asset> resultList = [];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
      );
    } catch (e) {
      showToast(e.message);
    }

    if (!mounted) return;

    ByteData byteData = await resultList[0].requestOriginal();
    Uint8List imageData = byteData.buffer.asUint8List();
    _selectedImage = imageData;
    Uint8List imageDataCompressed = Uint8List.fromList(
        await FlutterImageCompress.compressWithList(imageData));
    String result = await Qiniu.upload(imageDataCompressed);

    setState(() {
      qrcodeUrl = result;
    });
  }
}
