import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class Share {
  static final Share _instance = new Share._internal();

  Share._internal();

  factory Share() => _instance;

  static const channel = const MethodChannel('com.meizizi.doraemon/door');

  void share(context, List<String> pics, String text, int id) async {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: const Text('分享至微信朋友圈'),
                  onPressed: () => this.timeline(pics, text),
                ),
                CupertinoActionSheetAction(
                  child: const Text('分享至微信好友'),
                  onPressed: () => this.miniprogram(id, text),
                )
              ],
            ));
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
        userName: 'gh_1e6607d61edc',
        path: 'pages/index/index?tweetId=$id',
        description: text,
        thumbnail:
            'https://img.ippapp.com/155464043722716101?imageView2/0/interlace/1/q/50%7Cimageslim'));
  }
}
