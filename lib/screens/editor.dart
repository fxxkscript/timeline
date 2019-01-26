import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:wshop/components/asset.dart';
import 'dart:developer';

class Editor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditorState();
  }
}

class EditorState extends State<Editor> {
  static const maxPhotos = 9;

  List<Asset> images = List<Asset>();

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
              Navigator.of(context).maybePop();
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
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              )),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Material(
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                      maxLines: 6,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: '这一刻的想法...')),
                ),
                Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment(0, 0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.spaceBetween,
                      children: listWidget(),
                    )),
              ],
            ),
          ),
        ));
  }
}
