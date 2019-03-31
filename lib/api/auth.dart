import 'dart:async';

import 'package:flutter/widgets.dart';
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
    var response = await HttpClient().post(context, 'uc/auth/weappAuthorize', {
      'authDetail': {'authorizationCode': code},
      'authorizationType': 'wechat_app',
      'client': {'clientId': 'weapp_wtzz_v1'}
    });

    if (response != null) {
      HttpClient.setCache('accessToken', response['accessToken']);
      HttpClient.setCache('refreshToken', response['refreshToken']);
      return true;
    }
  } catch (e) {
    print(e);
    return false;
  }

  return false;
}

Future<void> getUserBasic({
  @required BuildContext context,
}) async {
  var response =
      await HttpClient().post(context, 'uc/userBasic/getUserBasicByUid', {});
  print(response);
  Auth().update(nickname: response['nickname'], avatar: response['avatar']);
  return response;
}

Future<void> checkLogin() async {
  var token = await HttpClient.getCache('accessToken');
  if (token == null) {
    throw Exception('未登录');
  }
  var mobile = await HttpClient.getCache('mobile');

  Auth().update(mobile: mobile, token: token);
}
