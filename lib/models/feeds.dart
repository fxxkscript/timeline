class Author {
  int uid;
  String nickname;
  String avatar;

  Author(this.uid, this.nickname, this.avatar);

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(json['uid'], json['nickname'], json['avatar']);
  }
}

class Feed {
  int id;
  Author author;
  String content;
  List<String> pics;
  String video;
  int sourceId;

  Feed(
      this.id, this.author, this.content, this.pics, this.video, this.sourceId);

  Map<String, dynamic> toJson() =>
      {'content': content, 'pics': pics, 'video': video, 'sourceId': sourceId};
}

class Feeds {
  bool hasNext;
  int nextCursor;
  List<Feed> list;

  Feeds(this.hasNext, this.nextCursor, this.list);

  factory Feeds.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return Feeds(false, 0, []);
    }
    List<Feed> list = [];

    json['list'].forEach((item) {
      List<String> pics = [];
      item['pics'].forEach((img) {
        pics.add(img);
      });

      list.add(Feed(item['id'], Author.fromJson(item['authorDTO']),
          item['content'], pics, item['video'], item['sourceId']));
    });

    return Feeds(json['hasNext'], json['nextCursor'], list);
  }
}
