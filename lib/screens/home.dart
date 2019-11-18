import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wshop/api/my.dart';
import 'package:wshop/models/notice.dart';
import 'package:wshop/screens/tabs/contacts.dart';
import 'package:wshop/screens/tabs/my.dart';
import 'package:wshop/screens/tabs/timeline.dart';
import 'package:wshop/utils/http_client.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ReceivePort _port = ReceivePort();
  int progress = 0;
  bool downloading;

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);

    this.initData();

    _prepare();
  }

  void initData() async {
    Notice notice = await getNotice();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => showNotice(context, notice));
  }

  void showNotice(BuildContext context, Notice notice) async {
    if (notice.content == null || notice.content.isEmpty) {
      return;
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Color.fromARGB(200, 237, 237, 237),
      content: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Flexible(
            child: Container(
                child: Text(
          notice.content,
          style: Theme.of(context).textTheme.body1,
        ))),
        IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).primaryColorDark),
          tooltip: '关闭',
          onPressed: () {
            _scaffoldKey.currentState.removeCurrentSnackBar();
          },
        ),
      ]),
      duration: Duration(seconds: notice.duration),
    ));
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  _prepare() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      var response = await HttpClient().get('version/version/get');

      var androidInfo = response['android'];
      if ((androidInfo['buildNumber'] &&
              androidInfo['buildNumber'] != buildNumber) ||
          androidInfo['version'] != version) {
        showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
                  title: Text('有新的版本可用，是否升级？'),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    FlatButton(
                      child: Text('关闭'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('升级',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          )),
                      onPressed: () {
                        _executeDownload(
                            androidInfo['url'], androidInfo['version']);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
    }
  }

  Future<void> _executeDownload(String url, String version) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
      String path = await _apkLocalPath;
      String fileName = "wshop_" + version + ".apk";
      await FlutterDownloader.enqueue(
          url: url,
          savedDir: path,
          fileName: fileName,
          showNotification: true,
          openFileFromNotification: true);
    } else {
      showToast('您拒绝了存储授权，无法完成升级');
    }
  }

  Future<String> get _apkLocalPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      setState(() {
        if (status == DownloadTaskStatus.running) {
          downloading = true;
          this.progress = progress;
        }
      });

      if (status == DownloadTaskStatus.complete) {
        FlutterDownloader.open(taskId: id);
        setState(() {
          this.progress = 0;
          downloading = false;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _scaffoldKey,
          body: Container(
            child: Stack(
              children: [
                CupertinoTabScaffold(
                  tabBar: CupertinoTabBar(
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          title: Text('动态'),
                          activeIcon: Image.asset('assets/timeline_active.png',
                              width: 22, height: 22),
                          icon: Image.asset('assets/timeline.png',
                              width: 22, height: 22)),
                      BottomNavigationBarItem(
                          title: Text('关注'),
                          activeIcon: Image.asset('assets/fav_active.png',
                              width: 22, height: 22),
                          icon: Image.asset('assets/fav.png',
                              width: 22, height: 22)),
                      BottomNavigationBarItem(
                          title: Text('我的'),
                          activeIcon: Image.asset('assets/mine_active.png',
                              width: 22, height: 22),
                          icon: Image.asset('assets/mine.png',
                              width: 22, height: 22)),
                    ],
                  ),
                  tabBuilder: (BuildContext context, int index) {
                    switch (index) {
                      case 0:
                        return TimelineTab();
                        break;
                      case 1:
                        return Contacts();
                        break;
                      case 2:
                        return MyTab();
                        break;
                      default:
                        return TimelineTab();
                        break;
                    }
                  },
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 2,
                    child: LinearProgressIndicator(
                        value: progress / 100.0,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}
