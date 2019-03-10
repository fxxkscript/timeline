import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:wshop/utils/http_client.dart';

Future<String> getToken({
  @required BuildContext context,
}) async {
  var response = await HttpClient().post(context, 'toolkit/uploadToken/get',
      {'materialType': 0, 'bizName': 'wtzz'});

  return response['token'];
}
