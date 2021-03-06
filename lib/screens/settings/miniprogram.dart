import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wshop/components/Back.dart';
import 'package:wshop/models/auth.dart';

class MiniScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MiniState();
  }
}

class MiniState extends State<MiniScreen> {
  @override
  Widget build(BuildContext context) {
    String link = 'https://wap.ippapp.com/skip?uid=${Auth().uid}';

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: Back(
            color: Theme.of(context).primaryColorDark,
          ),
          middle: Text('我的小程序码'),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '在微信，长按识别二维码',
                style: Theme.of(context).textTheme.body1,
              ),
              Text(
                '进入查看我的素材照片',
                style: Theme.of(context).textTheme.body1,
              ),
              QrImage(
                data: link,
                size: 200.0,
              ),
              FlatButton(
                  onPressed: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (_) => CupertinoActionSheet(
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: const Text('分享至微信朋友圈'),
                                  onPressed: () async {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('Discard');
                                    await fluwx.shareToWeChat(
                                        fluwx.WeChatShareImageModel(
                                            scene: fluwx.WeChatScene.TIMELINE,
                                            image:
                                                'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$link',
                                            title: '长按识别二维码，进入查看我的素材照片',
                                            thumbnail: Auth().avatar));
                                  },
                                ),
                                CupertinoActionSheetAction(
                                    child: const Text('分享至微信好友'),
                                    onPressed: () async {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('Discard');
                                      await fluwx.shareToWeChat(
                                          fluwx.WeChatShareImageModel(
                                              scene: fluwx.WeChatScene.SESSION,
                                              image:
                                                  'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$link',
                                              title: '长按识别二维码，进入查看我的素材照片',
                                              thumbnail: Auth().avatar));
                                    })
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
