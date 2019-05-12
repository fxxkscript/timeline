import 'dart:async';

import 'package:wshop/models/profile.dart';
import 'package:wshop/utils/http_client.dart';
import 'package:wshop/models/auth.dart';

Future<Profile> fetchProfile(context) async {
  final response = await HttpClient().get(context, 'feeds/userProfile/get', {'uid': Auth().uid.toString()});
  try {
    return new Profile.fromJson(response);
  } catch(e) {
    print(e);
  }
}