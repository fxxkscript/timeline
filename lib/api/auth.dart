import 'dart:async';

import 'package:wshop/models/auth.dart';

import 'package:wshop/utils/http_client.dart';

void getCode(context, String mobile) async {
  await HttpClient().post(context, 'account/auth/sendVerifyCode',
      {'mobile': mobile, 'sendType': 'sms'});
}

Future login(context, String mobile, String code) async {
  try {
    final response = await HttpClient().post(context, 'account/auth/verifyCode',
        {'mobile': mobile, 'verifyCode': code, 'clientId': 'app'});
    if (response != null) {
      HttpClient.setCache('accessToken', response['accessToken']);
      HttpClient.setCache('refreshToken', response['refreshToken']);
    }
  } catch (e) {
    print(e);
    return false;
  }

  return true;
}

Future<bool> loginByWechat(context, String code) async {
  try {
    final response =
        await HttpClient().post(context, 'uc/auth/weappAuthorize', {
      'authDetail': {'authorizationCode': code},
      'authorizationType': 'wechat_app',
      'client': {'clientId': 'weapp_wtzz_v1'}
    });
    print(response);
    if (response != null) {
      HttpClient.setCache('accessToken', response['accessToken']);
      HttpClient.setCache('refreshToken', response['refreshToken']);
      return true;
    }
  } catch (e) {
    print(e.toString());
    return false;
  }

  return false;
}

Future<Auth> isLogin() async {
  var token = await HttpClient.getCache('accessToken');
  print(token);
  if (token == null) {
    throw Exception('未登录');
  }

  return Auth().update(HttpClient.getCache('mobile'), token);
}
