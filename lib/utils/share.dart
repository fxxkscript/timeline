import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:image_downloader/image_downloader.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wshop/models/auth.dart';
import 'package:wshop/models/feeds.dart';
import 'package:wshop/screens/editor.dart';

import 'imageUtils.dart';

class Share {
  static final Share _instance = new Share._internal();

  Share._internal();

  factory Share() => _instance;

  static const channel = const MethodChannel('com.meizizi.doraemon/door');

  void share(
      {@required BuildContext context,
      @required Feed feed,
      Function refresh,
      Function block,
      Function delete}) async {
    Widget shareText;
    int tweetId = feed.id;
    List<String> pics = ImageUtils.getRawUrls(feed.pics);
    String text = feed.content;
    if (pics.length > 1 && Platform.isIOS) {
      shareText = const Text(
        '分享至微信朋友圈',
        style: TextStyle(color: const Color.fromRGBO(172, 172, 172, 1)),
      );
    } else {
      shareText = const Text('分享至微信朋友圈');
    }

    List<Widget> list = [
      CupertinoActionSheetAction(
        child: const Text('转发至我的相册'),
        onPressed: () {
          this.edit(context, pics, text, refresh);
        },
      ),
      CupertinoActionSheetAction(
        child: const Text('下载素材并复制文字'),
        onPressed: () async {
          if (pics.length > 0) {
            showToast('保存图片到本地相册中...', duration: Duration(seconds: 1));
          } else {
            showToast('复制中...', duration: Duration(seconds: 1));
          }

          Navigator.of(context, rootNavigator: true).pop('Discard');

          await Clipboard.setData(ClipboardData(text: text));
          for (var url in pics) {
            await ImageDownloader.downloadImage(url);
          }
          showToast('复制完成');
        },
      ),
      CupertinoActionSheetAction(
        child: shareText,
        onPressed: () {
          this.timeline(pics, text);
          Navigator.of(context, rootNavigator: true).pop('Discard');
        },
      ),
      CupertinoActionSheetAction(
        child: const Text('分享至微信好友'),
        onPressed: () {
          if (tweetId > 0) {
            this.miniprogram(tweetId, text, pics);
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

    if (Auth().uid == feed.author.uid && delete != null) {
      list.add(CupertinoActionSheetAction(
        child: const Text('删除'),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop('Discard');

          showDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                    title: Text('确定删除？'),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      FlatButton(
                        child: Text('取消'),
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
                          delete();
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
        await fluwx.shareToWeChat(fluwx.WeChatShareTextModel(
            text: text, scene: fluwx.WeChatScene.TIMELINE));
      } else {
        if (pics.length == 1 && Platform.isIOS) {
          await fluwx.shareToWeChat(fluwx.WeChatShareImageModel(
              image: pics[0],
              description: text,
              title: text,
              scene: fluwx.WeChatScene.TIMELINE));
        } else {
          await channel.invokeMethod('weixin', {'pics': pics, 'text': text});
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  void friends(List<String> pics, String text) async {
    await fluwx.shareToWeChat(fluwx.WeChatShareImageModel(
        image: pics[0], scene: fluwx.WeChatScene.SESSION));
  }

  Future<void> miniprogram(int id, String text, List<String> pics) async {
    await fluwx.shareToWeChat(fluwx.WeChatShareMiniProgramModel(
        webPageUrl: 'https://ippapp.com',
        userName: 'gh_8d035903cde6',
        path: 'pages/detail/index?tweetId=$id',
        description: text,
        thumbnail: (pics != null && pics.length > 0)
            ? pics[0]
            : 'http://img.ippapp.com/logo.png'));
  }
}
