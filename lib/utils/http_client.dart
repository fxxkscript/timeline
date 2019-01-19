import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpClient {
  static final HttpClient _instance = new HttpClient._internal();

  HttpClient._internal();

  factory HttpClient() => _instance;

  static const domain = 'https://api.shanpi.net/';

  Future post(
      BuildContext context, String endPoint, Map<String, dynamic> data) async {
    Map<String, String> headers = {
      'X-Client-Id': 'app',
      'X-Tid': '1',
      'Content-Type': 'application/json',
    };

    var token = await HttpClient.getCache('accessToken');
    if (token != null) {
      headers['X-Access-Token'] = token;
    }

    try {
      final response = await http.post(domain + endPoint,
          headers: headers, body: json.encode(data));

      var statusCode = response.statusCode;

      if (statusCode == 200) {
        return json.decode(response.body);
      } else if (statusCode == 401 && endPoint != 'account/auth/refreshToken') {
        await refreshToken();
      } else if (statusCode == 422 || statusCode == 511) {
        await setCache('token', '');
        // go to signin
        Navigator.pushNamedAndRemoveUntil(
            context, '/', (Route<dynamic> route) => false);
      }

      throw Exception('网络错误');
    } on Exception catch (e) {
      print(e);
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