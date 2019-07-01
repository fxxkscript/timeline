import 'dart:async';

import 'package:wshop/models/my.dart';
import 'package:wshop/utils/http_client.dart';

Future<My> fetchMy() async {
  try {
    final response = await HttpClient().get('uc/page/get');
    return new My.fromJson(response);
  } catch (e) {
    print(e);
    return new My();
  }
}
