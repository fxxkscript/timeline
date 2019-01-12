import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wshop/models/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void getCode(String mobile) async {
  final response = await http.post(
      'https://api.shanpi.net/account/auth/sendVerifyCode',
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mobile': mobile, 'sendType': 'sms'}));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
  } else {
    // If that call was not successful, throw an error.
    throw Exception('网络错误');
  }
}

Future<Auth> isLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  if (token == null) {
    throw Exception('未登录');
  }
  return Auth(prefs.getString('mobile'), token);
}
