import 'dart:async';

import 'package:wshop/models/auth.dart';
import 'package:wshop/utils/http_client.dart';

void getCode(String mobile) async {
  await HttpClient()
      .post('uc/auth/sendVerifyCode', {'mobile': mobile, 'sendType': 'sms'});
}

Future login(String mobile, String code) async {
  try {
    final response = await HttpClient().post('uc/auth/verifyCodeAuthorize', {
      "client": {"clientId": "weapp_wtzz_v1"},
      "authorizationType": "verify_code",
      "authDetail": {"mobile": mobile, "verifyCode": code, "source": ""}
    });
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

void logout() {
  HttpClient.setCache('accessToken', '');
  HttpClient.setCache('refreshToken', '');
}

Future<bool> loginByWechat(String code) async {
  try {
    var response = await HttpClient().post('uc/auth/weappAuthorize', {
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

Future<Auth> getUserBasic() async {
  final response = await HttpClient().post('uc/userBasic/getUserBasicByUid');
  return Auth().update(
      nickname: response['nickname'],
      avatar: response['avatar'],
      uid: response['uid']);
}

Future<bool> checkLogin() async {
  var token = await HttpClient.getCache('accessToken');
  if (token.isEmpty || token == null) {
    return false;
  }

  var mobile = await HttpClient.getCache('mobile');

  Auth().update(mobile: mobile, token: token);

  return true;
}
