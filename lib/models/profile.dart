import 'package:wshop/models/my.dart';

import 'author.dart';

class Detail {
  final int uid;
  final String wechatId;
  final String wechatQrCode;
  final String signature;

  Detail({this.uid, this.wechatId, this.wechatQrCode, this.signature});

  factory Detail.fromJson(Map<String, dynamic> json) {
    return new Detail(
        uid: json['uid'],
        wechatId: json['wechatId'],
        wechatQrCode: json['wechatQrCode'],
        signature: json['signature']);
  }
}

class Profile {
  final User user;
  final Detail detail;

  Profile({this.user, this.detail});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return new Profile(
      user: User.fromJson(json['user']),
      detail: Detail.fromJson(json['detail']),
    );
  }
}

class TimelineProfile {
  Author author;
  String signature;
  bool isFriend;
  int news;
  int tweets;

  TimelineProfile(
      {this.author, this.signature, this.isFriend, this.news, this.tweets});

  factory TimelineProfile.fromJson(Map<String, dynamic> json) {
    return TimelineProfile(
        author: Author.fromJson(json),
        signature: json['signature'],
        isFriend: json['isFriend'],
        news: json['news'],
        tweets: json['tweets']);
  }
}
