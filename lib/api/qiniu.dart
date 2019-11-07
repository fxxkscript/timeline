import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:wshop/utils/http_client.dart';

const channel = const MethodChannel('com.meizizi.doraemon/door');
Uuid uuid = new Uuid();
Dio dio = new Dio(BaseOptions(baseUrl: 'http://upload.qiniup.com'));

class Qiniu {
  static const TOKEN_NAME = 'qiniu_token';

  static Future<String> getToken() async {
    String token = await HttpClient.getCache(TOKEN_NAME);
    if (token != null && token.length > 0) {
      return token;
    }
    var response = await HttpClient().post(
        'toolkit/uploadToken/get', {'materialType': 0, 'bizName': 'wtzz'});

    token = response['token'];
    await HttpClient.setCache(TOKEN_NAME, token);
    return token;
  }

  static Future<String> refreshToken() async {
    var response = await HttpClient().post(
        'toolkit/uploadToken/get', {'materialType': 0, 'bizName': 'wtzz'});

    String token = response['token'];
    await HttpClient.setCache(TOKEN_NAME, token);
    return token;
  }

  static Future<String> upload(Uint8List data) async {
    String key = uuid.v1() + '.jpg';

    String token = await Qiniu.getToken();

    FormData formData = FormData.fromMap({
      'token': token,
      'key': key,
      'file': MultipartFile.fromBytes(data),
    });

    try {
      await dio.post('/', data: formData,
          onSendProgress: (int sent, int total) {
        print("$sent $total");
      });
    } on DioError catch (e) {
      if (e.response is Response) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
      await refreshToken();
      return await upload(data);
    }

    return key;
  }
}
