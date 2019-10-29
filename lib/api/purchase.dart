import 'dart:async';

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

Future<bool> verify(String purchaseId) async {
  try {
    final response =
        await HttpClient().get('uc/memberIntro/find', {purchaseId: purchaseId});
    return response;
  } catch (e) {
    print(e);
    return false;
  }
}
