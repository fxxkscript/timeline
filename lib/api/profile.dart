import 'dart:async';

import 'package:wshop/models/auth.dart';
import 'package:wshop/models/profile.dart';
import 'package:wshop/utils/http_client.dart';

Future<Profile> fetchProfile(context) async {
  try {
    final response = await HttpClient()
        .get('uc/profile/get', {'uid': Auth().uid.toString()});
    return new Profile.fromJson(response);
  } catch (e) {
    print(e);
    return new Profile();
  }
}

Future<bool> saveProfile(context, Map<String, String> data) async {
  try {
    final response = await HttpClient().post('uc/profileManage/save', data);
    return response["value"];
  } catch (e) {
    print(e);
    return false;
  }
}

Future<TimelineProfile> getTimelineProfile(context, int uid) async {
  try {
    final response = await HttpClient()
        .get('feeds/userProfile/timelineProfile', {'uid': uid.toString()});
    print(response);
    return TimelineProfile.fromJson(response);
  } catch (e) {
    print(e);
    return TimelineProfile();
  }
}
