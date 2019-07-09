import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wshop/components/Back.dart';

class FreeVideo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FreeVideoState();
  }
}

class FreeVideoState extends State<FreeVideo> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: Back(
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        child: Container(
          child: WebView(initialUrl: 'https://iqiyi.com'),
          margin: EdgeInsets.only(top: 90),
        ));
  }
}
