import 'dart:async';

import 'package:wshop/models/purchase.dart';
import 'package:wshop/utils/http_client.dart';

Future<List<Right>> fetchRights(context) async {
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
