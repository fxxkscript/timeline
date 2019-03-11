import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:wshop/utils/http_client.dart';

Future<String> findFollower(
    {@required BuildContext context, int page = 1, int pageSize = 1000}) async {
  var response = await HttpClient().post(context,
      'feeds/friendship/findFollower', {'pageNo': page, 'pageSize': pageSize});

  return response;
}

Future<String> findFriend(
    {@required BuildContext context, int page = 1, int pageSize = 1000}) async {
  var response = await HttpClient().post(context, 'feeds/friendship/findFriend',
      {'pageNo': page, 'pageSize': pageSize});
  print(response);
  return response;
}
