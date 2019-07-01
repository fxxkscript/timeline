import 'dart:async';

import 'package:wshop/models/feeds.dart';
import 'package:wshop/utils/http_client.dart';

Future<Feeds> getTimeline(int cursor, [int pageSize = 10]) async {
  try {
    var response = await HttpClient()
        .post('feeds/timeline/home', {'cursor': cursor, 'pageSize': pageSize});
    return Feeds.fromJson(response);
  } catch (e) {
    print(e);
    return Feeds.fromJson({});
  }
}

Future<Feeds> getUserFeeds(int userId, int cursor, [int pageSize = 10]) async {
  try {
    var response = await HttpClient().post('feeds/timeline/user', {
      'uid': userId,
      'cursorPaginationRequest': {'cursor': cursor, 'pageSize': pageSize}
    });
    return Feeds.fromJson(response);
  } catch (e) {
    print(e);
    return Feeds.fromJson({});
  }
}

Future<void> publish(Feed feed) async {
  try {
    await HttpClient().post('feeds/tweet/publish', feed.toJson());
  } catch (e) {
    print(e);
  }
}

Future<void> star(Feed feed) async {
  try {
    int id = feed.id;
    var response = await HttpClient().post('feeds/tweet/zan?tweetId=$id', {});
    print(response);
  } catch (e) {
    print(e);
  }
}
