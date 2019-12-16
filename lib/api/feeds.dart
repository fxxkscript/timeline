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

Future publish(Feed feed) async {
  try {
    return await HttpClient().post('feeds/tweet/publish', feed.toJson());
  } catch (e) {
    print(e);
  }
}

Future delete(Feed feed) async {
  try {
    int id = feed.id;
    return await HttpClient().post('feeds/tweet/delete', {'tweetId': id});
  } catch (e) {
    print(e);
  }
}

Future star(Feed feed) async {
  try {
    int id = feed.id;
    return await HttpClient().post('feeds/tweet/zan?tweetId=$id', {});
  } catch (e) {
    print(e);
  }
}

Future unstar(Feed feed) async {
  try {
    int id = feed.id;
    return await HttpClient().post('feeds/tweet/zan?tweetId=$id', {});
  } catch (e) {
    print(e);
  }
}

Future block(Feed feed) async {
  try {
    int id = feed.id;
    return await HttpClient().post('feeds/shield/shield?tweetId=$id', {});
  } catch (e) {
    print(e);
  }
}
