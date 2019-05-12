import 'dart:async';

import 'package:wshop/models/my.dart';
import 'package:wshop/utils/http_client.dart';

Future<My> fetchMy(context) async {
  final response = await HttpClient().get(context, 'uc/page/get');
  try {
    return new My.fromJson(response);
  } catch(e) {
    print(e);
  }
}