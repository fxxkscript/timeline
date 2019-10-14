import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:wshop/screens/editor.dart';

class Share {
  static final Share _instance = new Share._internal();

  Share._internal();

  factory Share() => _instance;

  static const channel = const MethodChannel('com.meizizi.doraemon/door');

  void share(BuildContext context, List<String> pics, String text,
      [int tweetId, Function refresh]) async {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: const Text('快速复制'),
                  onPressed: () {
                    this.edit(context, pics, text, refresh);
                    Navigator.of(context, rootNavigator: true).pop('Discard');
                  },
                ),
                CupertinoActionSheetAction(
                  child: const Text('分享至微信朋友圈'),
                  onPressed: () {
                    this.timeline(pics, text);
                    Navigator.of(context, rootNavigator: true).pop('Discard');
                  },
                ),
                CupertinoActionSheetAction(
                  child: const Text('分享至微信好友'),
                  onPressed: () {
                    if (tweetId > 0) {
                      this.miniprogram(tweetId, text);
                    } else {
                      this.friends(pics, text);
                    }
                    Navigator.of(context, rootNavigator: true).pop('Discard');
                  },
                )
              ],
            ));
  }

  Future<void> edit(BuildContext context, List<String> pics, String text,
      Function refresh) async {
    Navigator.pop(context);

    String result = await Navigator.of(context).push(CupertinoPageRoute(
        fullscreenDialog: true,
        title: '编辑',
        builder: (BuildContext context) => Editor(
              content: text,
              images: pics,
            )));

    if (result == 'save') {
      refresh();
    }
  }

  Future<void> timeline(List<String> pics, String text) async {
    try {
      if (pics.isEmpty) {
        await fluwx.share(fluwx.WeChatShareTextModel(
            text: text, scene: fluwx.WeChatScene.TIMELINE));
      } else {
        final int result =
            await channel.invokeMethod('weixin', {'pics': pics, 'text': text});
        debugPrint(result.toString());
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  void friends(List<String> pics, String text) async {
    await fluwx.share(fluwx.WeChatShareImageModel(
        image: pics[0], scene: fluwx.WeChatScene.SESSION));
  }

  void miniprogram(int id, String text) async {
    await fluwx.share(fluwx.WeChatShareMiniProgramModel(
        webPageUrl: 'https://ippapp.com',
        userName: 'gh_8d035903cde6',
        path: 'pages/index/index?tweetId=$id',
        description: text,
        thumbnail: 'http://img.ippapp.com/logo.png'));
  }
}
