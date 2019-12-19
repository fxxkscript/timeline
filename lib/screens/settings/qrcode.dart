import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wshop/components/Back.dart';
import 'package:wshop/models/auth.dart';

class QRCodeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QRCodeState();
  }
}

class QRCodeState extends State<QRCodeScreen> {
  @override
  Widget build(BuildContext context) {
    String link = 'https://wap.ippapp.com/focus.html?friend=${Auth().uid}';

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: Back(
            color: Theme.of(context).primaryColorDark,
          ),
          middle: Text('我的二维码'),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '扫码共享我的相册',
                style: Theme.of(context).textTheme.body1,
              ),
              Text(
                '下载小杯相册一键转图',
                style: Theme.of(context).textTheme.body1,
              ),
              QrImage(
                data: link,
                size: 200.0,
                embeddedImage: AssetImage('assets/logo.png'),
              ),
              FlatButton(
                  onPressed: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (_) => CupertinoActionSheet(
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: const Text('分享至微信朋友圈'),
                                  onPressed: () async => await fluwx.share(
                                      fluwx.WeChatShareWebPageModel(
                                          scene: fluwx.WeChatScene.TIMELINE,
                                          webPage: link,
                                          title: '关注我',
                                          thumbnail: Auth().avatar)),
                                ),
                                CupertinoActionSheetAction(
                                    child: const Text('分享至微信好友'),
                                    onPressed: () async => await fluwx.share(
                                        fluwx.WeChatShareWebPageModel(
                                            scene: fluwx.WeChatScene.SESSION,
                                            webPage: link,
                                            title: '关注我',
                                            thumbnail: Auth().avatar)))
                              ],
                            ));
                  },
                  child: Container(
                    width: 287,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                        child: Text(
                      '一键分享',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
                  ))
            ],
          ),
        ));
  }
}
