import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreenArgs {
  final String title;
  final String url;

  WebViewScreenArgs(this.title, this.url);
}

class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;

  WebViewScreen({Key key, @required this.title, @required this.url})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WebViewScreenState();
  }
}

class WebViewScreenState extends State<WebViewScreen> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();
  WebViewController controller;

  Future<String> loadJS(String name) async {
    var givenJS = rootBundle.loadString('assets/js/$name.js');
    return givenJS.then((String js) {
      flutterWebviewPlugin.onStateChanged.listen((viewState) async {
        if (viewState.type == WebViewState.finishLoad) {
          await flutterWebviewPlugin.evalJavascript(js);
        }
      });

      return Future.value('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.title ?? ''),
          leading: GestureDetector(
            child: Icon(
              Icons.close,
              color: Theme.of(context).primaryColorDark,
              size: 30,
            ),
            onTap: () async {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            debuggingEnabled: true,
            onWebViewCreated: (WebViewController c) async {
              controller = c;
            }));
  }
}
