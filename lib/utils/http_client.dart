import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpClient {
  static final HttpClient _instance = new HttpClient._internal();

  HttpClient._internal();

  factory HttpClient() => _instance;

  static const baseUrl = 'https://api.ippapp.com/';

  Dio dio = Dio(BaseOptions(baseUrl: baseUrl));

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

    try {
      final response = await this
          .dio
          .post(endPoint, options: Options(headers: headers), data: data);

      var statusCode = response.statusCode;
      if (statusCode == 200) {
        print("$statusCode $endPoint ${response.data}");
        print(response.data);
        return response.data;
      } else if (statusCode == 401 && endPoint != 'account/auth/refreshToken') {
        await refreshToken();
      } else if (statusCode == 422 || statusCode == 511) {
        await setCache('accessToken', '');
        // go to signin
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', (Route<dynamic> route) => false);
      }
    } on Exception catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future get(BuildContext context, String endPoint,
      [Map<String, String> params = const {}]) async {
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
    try {
      final response =
          await this.dio.get(endPoint, options: RequestOptions(headers: headers, queryParameters: params));
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        print("$statusCode $endPoint ${response.data}");
        return response.data;
      } else if (statusCode == 401 && endPoint != 'account/auth/refreshToken') {
        await refreshToken();
      } else if (statusCode == 422 || statusCode == 511) {
        await setCache('accessToken', '');
        // go to signin
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', (Route<dynamic> route) => false);
      }
    } on Exception catch (e) {
      print(e.toString());
      throw (e);
    }
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
}
