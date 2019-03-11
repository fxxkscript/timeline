class Auth {
  String mobile;
  String token;
  int uid;
  String nickname = '';
  String avatar;

  static final Auth _singleton = new Auth._internal();
  Auth._internal();

  factory Auth() {
    return _singleton;
  }

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth().update(json['mobile'], json['token']);
  }

  Auth update(String mobile, String token) {
    this.mobile = mobile;
    this.token = token;
    return Auth();
  }
}
