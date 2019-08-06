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
          await flutterWebviewPlugin.evalJavascript(js);
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
    Map<String, String> args = ModalRoute.of(context).settings.arguments;
    return WebviewScaffold(
      url: args['url'],
      clearCache: true,
      appCacheEnabled: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(args['title']),
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
//      bottomNavigationBar: BottomAppBar(
//        child: Row(
//          children: <Widget>[
//            FlatButton(
//              color: Theme.of(context).primaryColor,
//              child: Text('线路1'),
//              onPressed: () async {
//                String link = await flutterWebviewPlugin
//                    .evalJavascript('window.location.href');
//
//                String url = 'http://zy.1717yun.com/1717yun/?url=' + link;
//
//                flutterWebviewPlugin.launch(url);
//              },
//            )
//          ],
//        ),
//      ),
    );
  }
}
