import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpClient {
  static final HttpClient _instance = new HttpClient._internal();
  Dio dio;

  HttpClient._internal() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.interceptors.add(InterceptorsWrapper(onError: (DioError e) async {
      var context = e.request.extra['context'];
      if (e.response.statusCode == 401 &&
          e.request.path != 'account/auth/refreshToken') {
        await refreshToken();
      } else if (e.response.statusCode == 422 || e.response.statusCode == 511) {
        await setCache('accessToken', '');
        // go to signin
        Navigator.pushReplacementNamed(context, '/login');
      }
    }));
  }

  factory HttpClient() => _instance;

  static const baseUrl = 'https://api.ippapp.com/';

  Future post(BuildContext context, String endPoint,
      [Map<String, dynamic> data = const {}]) async {
    Map<String, String> headers = {
      'X-Client-Id': 'weapp_wtzz_v1',
      'X-Tid': '1',
      'Content-Type': 'application/json',
    };
    var token = await HttpClient.getCache('accessToken');
    if (token != null) {
      headers['X-Access-Token'] = token;
    }

    print("post $endPoint $data");

    final response = await this.dio.post(endPoint,
        options: Options(headers: headers, extra: {'context': context}),
        data: data);

    var statusCode = response.statusCode;
    print("$statusCode $endPoint ${response.data}");
    return response.data;
  }

  Future get(BuildContext context, String endPoint,
      [Map<String, dynamic> params = const {}]) async {
    Map<String, String> headers = {
      'X-Client-Id': 'weapp_wtzz_v1',
      'X-Tid': '1',
      'Content-Type': 'application/json',
    };
    var token = await HttpClient.getCache('accessToken');
    if (token != null) {
      headers['X-Access-Token'] = token;
    }
    print("get $endPoint $params");

    final response = await this.dio.get(endPoint,
        options: RequestOptions(headers: headers, queryParameters: params));
    var statusCode = response.statusCode;
    print("$statusCode $endPoint ${response.data}");
    return response.data;
  }

  refreshToken() async {}

  static getCache(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  static setCache(String key, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(
        key, (value != null && value.length > 0) ? value : "");
  }

  static catchRequestError(e) {
    if (e.response is Response) {
      return e.response.data["message"];
    } else {
      return e.message;
    }
  }
}
