import 'package:wshop/models/author.dart';

class Follower extends Author {
  bool isFriend;

  Follower(int uid, String nickname, String avatar, this.isFriend)
      : super(uid, nickname, avatar);

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
        json['uid'], json['nickname'], json['avatar'], json['isFriend']);
  }
}
