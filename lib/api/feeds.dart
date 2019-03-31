import 'dart:async';

import 'package:wshop/models/feeds.dart';
import 'package:wshop/utils/http_client.dart';

Future<Feeds> getTimeline(context, int cursor, [int pageSize = 10]) async {
  try {
    var response = await HttpClient().post(context, 'feeds/timeline/home',
        {'cursor': cursor, 'pageSize': pageSize});
    print(response);
    return Feeds.fromJson(response);
  } catch (e) {
    print(e);
    return Feeds.fromJson({});
  }
}

Future<void> publish(context, Feed feed) async {
  try {
    var response =
        await HttpClient().post(context, 'feeds/tweet/publish', feed.toJson());
  } catch (e) {
    print(e);
  }
}

Future<void> star(context, Feed feed) async {
  try {
    int id = feed.id;
    var response =
        await HttpClient().post(context, 'feeds/tweet/zan?tweetId=$id', {});
    print(response);
  } catch (e) {
    print(e);
  }
}
