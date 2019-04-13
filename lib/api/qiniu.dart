import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wshop/models/auth.dart';
import 'package:wshop/utils/http_client.dart';

const channel = const MethodChannel('com.meizizi.doraemon/door');

Future<String> getToken({
  @required BuildContext context,
}) async {
  var response = await HttpClient().post(context, 'toolkit/uploadToken/get',
      {'materialType': 0, 'bizName': 'wtzz'});

  return response['token'];
}

Future upload(BuildContext context, Uint8List data) async {
  String token = await getToken(context: context);

  String key = (new DateTime.now()).millisecondsSinceEpoch.toString() +
      Random(Auth().uid).nextInt(100000).toString();

  var result = await channel.invokeMethod('upload',
      <String, dynamic>{'imageData': data, 'token': token, 'key': key});

  print(result);

  return key;
}
