import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:wshop/models/auth.dart';
import 'package:wshop/models/feeds.dart';
import 'package:wshop/screens/editor.dart';

class Share {
  static final Share _instance = new Share._internal();

  Share._internal();

  factory Share() => _instance;

  static const channel = const MethodChannel('com.meizizi.doraemon/door');

  void share(BuildContext context, Feed feed,
      [Function refresh, Function block]) async {
    Widget shareText;
    int tweetId = feed.id;
    List<String> pics = feed.pics;
    String text = feed.content;
    if (pics.length > 1) {
      shareText = const Text(
        '分享至微信朋友圈',
        style: TextStyle(color: const Color.fromRGBO(172, 172, 172, 1)),
      );
    } else {
      shareText = const Text('分享至微信朋友圈');
    }

    List<Widget> list = [
      CupertinoActionSheetAction(
        child: const Text('快速复制'),
        onPressed: () {
          this.edit(context, pics, text, refresh);
          Navigator.of(context, rootNavigator: true).pop('Discard');
        },
      ),
      CupertinoActionSheetAction(
        child: shareText,
        onPressed: () {
          if (pics.length <= 1) {
            this.timeline(pics, text);
            Navigator.of(context, rootNavigator: true).pop('Discard');
          }
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
    ];

    if (block != null && Auth().uid != feed.author.uid) {
      list.add(CupertinoActionSheetAction(
        child: const Text('投诉 屏蔽'),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop('Discard');
          print(111);

          showDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                    title: Text('确定投诉屏蔽？'),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      FlatButton(
                        child: Text('关闭'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('确定',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            )),
                        onPressed: () {
                          block();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
        },
      ));
    }

    showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
              actions: list,
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
        await fluwx.share(fluwx.WeChatShareImageModel(
            image: pics[0],
            description: text,
            title: text,
            scene: fluwx.WeChatScene.TIMELINE));
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  void friends(List<String> pics, String text) async {
    await fluwx.share(fluwx.WeChatShareImageModel(
        image: pics[0], scene: fluwx.WeChatScene.SESSION));
  }

  Future<void> miniprogram(int id, String text) async {
    await fluwx.share(fluwx.WeChatShareMiniProgramModel(
        webPageUrl: 'https://ippapp.com',
        userName: 'gh_8d035903cde6',
        path: 'pages/index/index?tweetId=$id',
        description: text,
        thumbnail: 'http://img.ippapp.com/logo.png'));
  }
}
