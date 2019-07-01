import 'dart:async';

import 'package:wshop/models/withdraw.dart';
import 'package:wshop/utils/http_client.dart';

Future<UserAsset> fetchUserAsset() async {
  try {
    final response = await HttpClient().get('trade/asset/user');
    return UserAsset.fromJson(response);
  } catch (e) {
    print(e);
    return UserAsset();
  }
}
