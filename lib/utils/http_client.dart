import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wshop/screens/app.dart';

class HttpClient {
  static final HttpClient _instance = new HttpClient._internal();
  Dio dio;

  Map<String, String> headers = {
    'X-Client-Id': 'weapp_wtzz_v1',
    'X-Tid': '1',
    'Content-Type': 'application/json',
  };

  HttpClient._internal() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      var token = await HttpClient.getCache('accessToken');
      if (token != null) {
        options.headers['X-Access-Token'] = token;
      }
      return options;
    }, onError: (DioError e) async {
      if (e.response.statusCode == 401 &&
          e.request.path != 'account/auth/refreshToken') {
        dio.interceptors.requestLock.lock();
        await refreshToken();
        dio.interceptors.requestLock.unlock();

        try {
          var resp;
          if (e.request.method == 'get') {
            resp = await this.get(e.request.path, e.request.data);
          } else {
            resp = await this.post(e.request.path, e.request.data);
          }
          dio.resolve(resp);
        } catch (e) {
          dio.reject(e);
        }
        return null;
      } else if (e.response.statusCode == 422 || e.response.statusCode == 511) {
        await setCache('accessToken', '');
        await setCache('refreshToken', '');
        // go to signin
        return runApp(App('/login'));
      } else {
        return e;
      }
    }));
  }

  factory HttpClient() => _instance;

  static const baseUrl = 'https://api.ippapp.com/';

  Future post(String endPoint, [Map<String, dynamic> data = const {}]) async {
    print("post $endPoint $data");

    final response = await this
        .dio
        .post(endPoint, options: Options(headers: headers), data: data);

    var statusCode = response.statusCode;
    print("$statusCode $endPoint ${response.data}");
    return response.data;
  }

  Future get(String endPoint, [Map<String, dynamic> params = const {}]) async {
    print("get $endPoint $params");

    final response = await this.dio.get(endPoint,
        options: RequestOptions(headers: headers, queryParameters: params));
    var statusCode = response.statusCode;
    print("$statusCode $endPoint ${response.data}");
    return response.data;
  }

  Future<String> refreshToken() async {
    String refreshToken = await HttpClient.getCache('refreshToken');

    var response = await this.dio.post('account/auth/refreshToken',
        options: Options(headers: headers),
        data: {
          'client': {'clientId': 'app'},
          'authorizationType': 'refresh_token',
          'authDetail': {'refreshToken': refreshToken}
        });

    await HttpClient.setCache('accessToken', response.data);

    return response.data;
  }

  static getCache(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  static setCache(String key, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(
        key, (value != null && value.length > 0) ? value : '');
  }

  static catchRequestError(e) {
    if (e.response is Response) {
      return e.response.data['message'];
    } else {
      return e.message;
    }
  }
}
