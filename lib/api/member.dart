import 'dart:async';

import 'package:wshop/utils/http_client.dart';

Future createMember(String code) async {
  try {
    return await HttpClient().get('uc/member/create', {"code": code});
  } catch (e) {
    throw HttpClient.catchRequestError(e);
  }
}
