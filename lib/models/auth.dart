class Auth {
  String mobile;
  String token;
  int uid;
  String nickname = '';
  String avatar = '';

  static final Auth _singleton = new Auth._internal();
  Auth._internal();

  factory Auth() {
    return _singleton;
  }

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth().update(mobile: json['mobile'], token: json['token']);
  }

  Auth update(
      {String mobile, String token, String avatar = '', String nickname = ''}) {
    this.mobile = mobile;
    this.token = token;
    this.avatar = avatar;
    this.nickname = nickname;
    return Auth();
  }
}
