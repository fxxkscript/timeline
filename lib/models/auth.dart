class Auth {
  String mobile;
  String token;
  int uid;
  String nickname = '';
  String avatar = '';
  Member member;

  static final Auth _singleton = new Auth._internal();

  Auth._internal();

  factory Auth() {
    return _singleton;
  }

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth().update(mobile: json['mobile'], token: json['token']);
  }

  Auth update(
      {int uid,
      String mobile,
      String token,
      String avatar = 'http://img.ippapp.com/logo.png',
      String nickname = '',
      Member member}) {
    this.uid = uid;
    this.mobile = mobile;
    this.token = token;
    this.avatar = avatar;
    this.nickname = nickname;
    this.member = member;
    return Auth();
  }
}

class Member {
  bool isActive;
  bool isNotEnd;
  String startAt;
  String endAt;

  Member({this.isActive, this.isNotEnd, this.startAt, this.endAt});

  factory Member.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) {
      return Member(isActive: false, isNotEnd: false, startAt: '', endAt: '');
    }
    return Member(
      isActive: json['isActive'],
      isNotEnd: json['isNotEnd'],
      startAt: json['startAt'],
      endAt: json['endAt'],
    );
  }
}
