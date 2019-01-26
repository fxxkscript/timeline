import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Editor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditorState();
  }
}

class EditorState extends State<Editor> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
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
                      alignment: WrapAlignment.start,
                      children: <Widget>[
                        Image.network(
                            'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover),
                        Image.network(
                            'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover),
                        Image.network(
                            'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover),
                        ButtonTheme(
                            child: FlatButton(
                              color: Colors.grey,
                              child: Icon(Icons.add),
                              onPressed: () {
                                CupertinoActionSheet();
                              },
                            ),
                            minWidth: 120,
                            height: 120)
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
