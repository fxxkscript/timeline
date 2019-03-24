import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:wshop/api/feeds.dart';
import 'package:wshop/api/qiniu.dart';
import 'package:wshop/components/asset.dart';
import 'package:wshop/models/auth.dart';
import 'package:wshop/models/author.dart';
import 'package:wshop/models/feeds.dart';

class Editor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditorState();
  }
}

class EditorState extends State<Editor> {
  static const channel = const MethodChannel('com.meizizi.doraemon/door');

  static const maxPhotos = 9;

  List<Asset> images = List<Asset>();
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void disponse() {
    textController.dispose();

    super.dispose();
  }

  Future getImage() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maxPhotos,
        enableCamera: true,
      );
    } catch (e) {
//      error = e.message;
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  List<Widget> listWidget() {
    List<Widget> list = List.generate(images.length, (index) {
      return AssetView(Key(images[index].name), images[index], (String name) {
        images.removeWhere((asset) => asset.name == name);

        setState(() {});
      });
    });
    if (list.length < maxPhotos) {
      list.add(ButtonTheme(
          child: FlatButton(
            color: Colors.grey,
            child: Icon(Icons.add),
            onPressed: getImage,
          ),
          minWidth: 120,
          height: 120));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
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
                color: Colors.green,
                child: const Text(
                  '发表',
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.zero,
                onPressed: () async {
                  List<String> imgList = [];
                  images.forEach((img) async {
                    ByteData byteData = await img.requestOriginal();
                    Uint8List imageData = byteData.buffer.asUint8List();
                    String key = await upload(context, imageData);
                    imgList.add(key);
                    img.releaseOriginal();
                  });

                  await publish(
                      context,
                      Feed(
                          0,
                          0,
                          Author(Auth().uid, Auth().nickname, Auth().avatar),
                          textController.text,
                          imgList,
                          '',
                          0,
                          ''));
                  Navigator.pop(context, 'save');
                },
              )),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Material(
            child: ListView(
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
          ),
        ));
  }
}
