import 'dart:convert';

import 'package:wshop/models/author.dart';

class Feed {
  int id;
  Author author;
  String content;
  List<String> pics;
  String video;
  int sourceId;
  int star;
  String createdAt;

  Feed(this.id, this.star, this.author, this.content, this.pics, this.video,
      this.sourceId, this.createdAt);

  Map<String, dynamic> toJson() =>
      {'content': content, 'pics': pics, 'video': video, 'sourceId': sourceId};
}

class Feeds {
  bool hasNext;
  int nextCursor;
  List<Feed> list;

  Feeds(this.hasNext, this.nextCursor, this.list);

  factory Feeds.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return Feeds(false, 0, []);
    }
    List<Feed> list = [];

    json['list'].forEach((item) {
      List<String> pics = [];
      List<dynamic> data = item['pics'];
      data.forEach((img) {
        Map newImg = jsonDecode(img);
        pics.add(newImg['pic']);
      });

      list.add(Feed(
          item['id'],
          item['zanNum'],
          Author.fromJson(item['authorDTO']),
          item['content'],
          pics,
          item['video'],
          item['sourceId'],
          item['createdAt']));
    });

    return Feeds(json['hasNext'], json['nextCursor'], list);
  }
}
