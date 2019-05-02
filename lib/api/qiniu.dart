import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wshop/models/auth.dart';
import 'package:wshop/utils/http_client.dart';

const channel = const MethodChannel('com.meizizi.doraemon/door');

class Qiniu {
  static Future<String> getToken({
    @required BuildContext context,
  }) async {
    var response = await HttpClient().post(context, 'toolkit/uploadToken/get',
        {'materialType': 0, 'bizName': 'wtzz'});

    return response['token'];
  }

  static Future<String> upload(
      BuildContext context, Uint8List data, String token) async {
    String key = DateTime.now().millisecondsSinceEpoch.toString() +
        Random(Auth().uid).nextInt(100000).toString() +
        '.jpg';

    await channel.invokeMethod('upload',
        <String, dynamic>{'imageData': data, 'token': token, 'key': key});

    return key;
  }
}
