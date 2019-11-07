import 'package:wshop/models/author.dart';

enum MediaType {
  image,
  video,
}

class Feed {
  int id;
  Author author;
  String content;
  List<String> pics;
  String video;
  int sourceId;
  int star;
  bool isZan;
  String createdAt;
  MediaType type;

  Feed(
      {id = 0,
      star,
      author,
      content = '',
      this.pics = const [],
      this.video = '',
      this.sourceId = 0,
      this.createdAt = '',
      this.isZan = false});

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

      item['pics'].forEach((img) {
        pics.add(img.toString());
      });

      list.add(Feed(
          id: item['id'],
          star: item['zanNum'],
          author: Author.fromJson(item['authorDTO']),
          content: item['content'],
          pics: pics,
          video: item['video'],
          sourceId: item['sourceId'],
          createdAt: item['createdAt'],
          isZan: item['isZan']));
    });

    return Feeds(json['hasNext'], json['nextCursor'], list);
  }
}
