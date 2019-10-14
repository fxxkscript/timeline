import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:wshop/api/feeds.dart';
import 'package:wshop/api/qiniu.dart';
import 'package:wshop/components/Asset.dart';
import 'package:wshop/models/assetUrlImage.dart';
import 'package:wshop/models/auth.dart';
import 'package:wshop/models/author.dart';
import 'package:wshop/models/feeds.dart';

class Editor extends StatefulWidget {
  final String content;
  final List<String> images;

  Editor({this.content, this.images});

  @override
  State<StatefulWidget> createState() {
    return EditorState();
  }
}

class EditorState extends State<Editor> {
  static const channel = const MethodChannel('com.meizizi.doraemon/door');

  static const maxPhotos = 9;
  bool saving = false;

  List<dynamic> images = [];
  File video;
  MediaType type;

  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textController.text = widget.content;
    widget.images?.forEach((img) {
      images.add(AssetUrlImage(img));
    });
  }

  @override
  void dispose() {
    textController.dispose();

    super.dispose();
  }

  void getVideo() async {
    var tmp = await ImagePicker.pickVideo(source: ImageSource.gallery);

    setState(() {
      video = tmp;
      type = MediaType.video;
    });
  }

  void getImage() async {
    List<Asset> resultList = [];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maxPhotos - images.length,
        enableCamera: true,
        materialOptions: MaterialOptions(
          actionBarTitle: "选择图片",
          allViewTitle: "所有图片",
          selectionLimitReachedText: "不能再选了",
        ),
      );
    } catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      type = MediaType.image;
      images = List.from(images)..addAll(resultList);
    });
  }

  List<Widget> listWidget() {
    List<Widget> list = List.generate(images.length, (index) {
      if (images[index].runtimeType == AssetUrlImage) {
        return AssetView(Key(images[index].url), images[index], (String name) {
          images.removeWhere((asset) => asset.url == name);

          setState(() {});
        });
      } else {
        return AssetView(Key(images[index].name), images[index], (String name) {
          images.removeWhere((asset) => asset.name == name);

          setState(() {});
        });
      }
    });

    Widget addBtn = ButtonTheme(
        child: FlatButton(
          color: Colors.grey,
          child: Icon(Icons.add),
          onPressed: choose,
        ),
        minWidth: 120,
        height: 120);

    if (list.length < maxPhotos && type == MediaType.image) {
      list.add(addBtn);
    } else if (list.length < 1) {
      list.add(addBtn);
    }

    return list;
  }

  post() async {
    if (textController.text.length > 0 || images.length > 0 || video != null) {
      setState(() {
        saving = true;
      });

      List<String> list = [];
      String videoUrl = '';
      if (type == MediaType.image) {
        await Future.wait(images.map((img) async {
          if (img.runtimeType == Asset) {
            ByteData byteData = await img.requestOriginal();
            Uint8List imageData = byteData.buffer.asUint8List();
            Uint8List imageDataCompressed = Uint8List.fromList(
                await FlutterImageCompress.compressWithList(imageData));
            String key = await Qiniu.upload(imageDataCompressed);
            list.add(key);
          } else {
            String key = img.url
                .replaceAll(RegExp(r'\-tweet_pic_v1'), '')
                .replaceAll('http://img.ippapp.com/', '')
                .replaceAll('https://img.ippapp.com/', '');
            list.add(key);
          }
        }));
      } else if (type == MediaType.video) {
        if (video.path.indexOf('file://') == 0) {
          video = File(
            video.path.split('file://')[1],
          );
        }
        videoUrl = await Qiniu.upload(video.readAsBytesSync());
      }

      await publish(Feed(
          author: Author(Auth().uid, Auth().nickname, Auth().avatar),
          content: textController.text,
          pics: list,
          video: videoUrl));

      setState(() {
        saving = false;
      });

      Navigator.pop(context, 'save');
    }
  }

  choose() {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: const Text('选择照片'),
                  onPressed: () {
                    getImage();
                    Navigator.of(context, rootNavigator: true).pop('Discard');
                  },
                ),
                CupertinoActionSheetAction(
                  child: const Text('选择视频'),
                  onPressed: () {
                    getVideo();
                    Navigator.of(context, rootNavigator: true).pop('Discard');
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    String title = saving ? '上传中...' : '发表';

    var list = List<Widget>();

    list.addAll(<Widget>[
      ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
                controller: textController,
                maxLines: 6,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: '这一刻的想法...')),
          ),
          Center(
              child: SizedBox(
                  width: 380,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.start,
                    children: listWidget(),
                  ))),
        ],
      ),
    ]);

    if (saving) {
      list.add(Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: const ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          Center(
            child: const CircularProgressIndicator(),
          ),
        ],
      ));
    }

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('发表动态'),
          leading: CupertinoButton(
            child: const Text('取消'),
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context, 'cancel');
            },
          ),
          trailing: ButtonTheme(
              minWidth: 60,
              height: 30,
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                disabledColor: Theme.of(context).primaryColor,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.zero,
                onPressed: saving ? null : post,
              )),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Material(
            child: Stack(children: list),
          ),
        ));
  }
}
