import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:wshop/models/purchase.dart';
import 'package:wshop/utils/http_client.dart';

Future<List<Right>> fetchRights() async {
  try {
    final response = await HttpClient().get('uc/memberIntro/find');
    return List<Right>.from(response.map((model) => new Right.fromJson(model)))
        .reversed
        .toList();
  } catch (e) {
    print(e);
    return [];
  }
}

Future<bool> verify(
    String purchaseId, String productId, PurchaseVerificationData data) async {
  try {
    final response = await HttpClient().post('trade/applePay/notify', {
      'receipt': purchaseId,
      'data': data.serverVerificationData,
      'productId': productId
    });
    return response;
  } catch (e) {
    print(e);
    return false;
  }
}
