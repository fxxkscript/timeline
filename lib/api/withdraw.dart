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

Future withdrawMoney(context, amount, qrcodeUrl) async {
  try {
    return await HttpClient().post('trade/asset/withdraw', {
      "amount": amount,
      "ownership_qr_code": qrcodeUrl
    });
  } catch (e) {
    throw HttpClient.catchRequestError(e);
  }
}