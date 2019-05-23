import 'dart:async';

import 'package:wshop/models/member.dart';
import 'package:wshop/utils/http_client.dart';

Future<Member> fetchMemberInfo(context) async {
  final response = await HttpClient().get(context, 'uc/page/get');
  try {
    return new Member.fromJson(response);
  } catch (e) {
    print(e);
    return new Member();
  }
}

Future<String> createActivation(context) async {
  final response = await HttpClient().post(context, 'uc/card/create', {
    "codePrefix": "PZ",
    "name": "高级会员年卡",
    "levelId": 3,
    "memberActiveTime": 31536000,
    "startAt": "2019-05-19 21:00:00",
    "endAt": "2022-05-19 00:00:00"
  });
  return response['code'];
}

Future createMember(context, String code) async {
  return await HttpClient().get(context, 'uc/member/create', { "code": code });
}