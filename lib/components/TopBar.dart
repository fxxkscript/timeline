import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wshop/screens/editor.dart';

class TopBar extends StatelessWidget {
  TopBar({this.subject, this.refresh});

  final PublishSubject<int> subject;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
        stream: subject.stream.debounce(Duration(milliseconds: 100)),
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: MediaQuery.of(context).size.width,
            height: 42 + MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
                color: Color.fromARGB(snapshot.data, 237, 237, 237)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(''),
                ),
                Expanded(
                  flex: 4,
                  child: Text('',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 17)),
                ),
                Expanded(
                  flex: 1,
                  child: ButtonTheme(
                    minWidth: 60,
                    height: 30,
                    child: Container(
                        margin: EdgeInsets.only(right: 16),
                        child: CupertinoButton(
                          child: Icon(Icons.photo_camera),
                          padding: EdgeInsets.only(bottom: 0),
                          onPressed: () async {
                            String result = await Navigator.of(context).push(
                                CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    title: '新建',
                                    builder: (BuildContext context) =>
                                        Editor()));

                            if (result == 'save') {
                              refresh();
                            }
                          },
                        )),
                  ),
                )
              ],
            ),
          );
        });
  }
}
