import 'dart:async';

import 'package:wshop/models/author.dart';
import 'package:wshop/models/follower.dart';
import 'package:wshop/utils/http_client.dart';

Future<Map<String, dynamic>> findFollower(
    {int page = 1, int pageSize = 1000}) async {
  var response = await HttpClient().post(
      'feeds/friendship/findFollower', {'pageNo': page, 'pageSize': pageSize});

  Map<String, dynamic> result = {'count': response['count']};

  result['list'] = List<Follower>();
  response['list'].forEach((item) {
    result['list'].add(Follower.fromJson(item));
  });

  return result;
}

Future<Map<String, dynamic>> findFriend(
    {int page = 1, int pageSize = 1000}) async {
  var response = await HttpClient().post(
      'feeds/friendship/findFriend', {'pageNo': page, 'pageSize': pageSize});

  Map<String, dynamic> result = {'count': response['count']};
  result['list'] = List<Author>();
  response['list'].forEach((item) {
    result['list'].add(Author.fromJson(item));
  });

  return result;
}

Future<bool> addFriend({int id}) async {
  var response =
      await HttpClient().post('feeds/friendship/addFriend?friendId=$id', {});
  print(response);
  return response['value'];
}

Future<bool> cancelFriend({int id}) async {
  var response =
      await HttpClient().post('feeds/friendship/cancelFriend?friendId=$id', {});
  print(response);
  return response['value'];
}
