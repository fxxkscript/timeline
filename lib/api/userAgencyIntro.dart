import 'dart:async';

import 'package:wshop/models/userAgencyIntro.dart';
import 'package:wshop/utils/http_client.dart';

Future<UserAgencyIntroData> fetchUserAgencyIntro() async {
  try {
    final response = await HttpClient().get('uc/agency/getUserAgencyIntro');
    return UserAgencyIntroData.fromJson(response);
  } catch (e) {
    print(e);
    return UserAgencyIntroData();
  }
}

Future invitedByCode(String invitationCode) async {
  try {
    return await HttpClient()
        .get('uc/invitation/invitedByCode', {"invitationCode": invitationCode});
  } catch (e) {
    throw HttpClient.catchRequestError(e);
  }
}
