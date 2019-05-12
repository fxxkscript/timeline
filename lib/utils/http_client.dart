import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class HttpClient {
  static final HttpClient _instance = new HttpClient._internal();

  HttpClient._internal();

  factory HttpClient() => _instance;

  static const domain = 'api.ippapp.com';

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

    try {
      var url = RegExp(r'^(https?:)?//').hasMatch(endPoint)
          ? endPoint
          : Uri.https(domain, endPoint);
      final response =
          await http.post(url, headers: headers, body: json.encode(data));
      var statusCode = response.statusCode;
      print("port $statusCode $url ${json.encode(data)}");
      if (statusCode == 200) {
        var result = json.decode(response.body);
        print(json.encode(result));
        return result;
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

    try {
      var url = RegExp(r'^(https?:)?//').hasMatch(endPoint)
          ? endPoint
          : Uri.https(domain, endPoint, params);
      final response = await http.get(url, headers: headers);
      var statusCode = response.statusCode;
      print("get $statusCode $url");
      if (statusCode == 200) {
        var result = json.decode(response.body);
        print(json.encode(result));
        return result;
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
