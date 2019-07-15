import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class FreeVideo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FreeVideoState();
  }
}

class FreeVideoState extends State<FreeVideo> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  Future<String> loadJS(String name) async {
    var givenJS = rootBundle.loadString('assets/js/$name.js');
    return givenJS.then((String js) {
      flutterWebviewPlugin.onStateChanged.listen((viewState) async {
        if (viewState.type == WebViewState.finishLoad) {
          flutterWebviewPlugin.evalJavascript(js);
        }
      });

      return Future.value('');
    });
  }

  @override
  void initState() {
    loadJS('test');

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
