import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class FreeVideo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FreeVideoState();
  }
}

class FreeVideoState extends State<FreeVideo> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
//    this.flutterWebviewPlugin.evalJavascript('alert(1111);');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: 'https://www.iqiyi.com',
      appBar: AppBar(
        title: Text('爱奇艺'),
      ),
    );
  }
}
