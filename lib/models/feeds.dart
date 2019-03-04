class Feed {
  String content;
  List<String> pics;
  String video;
  int sourceId;

  Feed(this.content, this.pics, this.video, this.sourceId);

  Map<String, dynamic> toJson() =>
      {'content': content, 'pics': pics, 'video': video, 'sourceId': sourceId};
}

class Feeds {
  bool hasNext;
  int nextCursor;
  List<Feed> list;

  Feeds(this.hasNext, this.nextCursor, this.list);

  factory Feeds.fromJson(Map<String, dynamic> json) {
    List<Feed> list = [];
    json['list'].forEach((item) => {
          list.add(Feed(
              item['content'], item['pics'], item['video'], item['sourceId']))
        });

    return Feeds(json['hasNext'], json['nextCursor'], list);
  }
}
