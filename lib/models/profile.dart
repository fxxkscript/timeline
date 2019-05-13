import 'package:wshop/models/my.dart';


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