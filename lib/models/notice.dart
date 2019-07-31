import 'author.dart';

class Notice {
  String content;
  int duration;
  Author author;

  Notice({this.content, this.duration, this.author});

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
        content: json['content'],
        author: Author.fromJson(json['author']),
        duration: json['duration'] ?? 15);
  }
}
