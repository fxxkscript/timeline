class Auth {
  String mobile;
  String token;
  int uid;
  String nickname = '';
  String avatar =
      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555245805&di=9eee289aff51c8925786add15309f736&imgtype=jpg&er=1&src=http%3A%2F%2Fimg5.hao123.com%2Fdata%2F1_42242836bf29aca0fb3dab75b4a9f9b6_510';

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
    this.avatar = avatar.isNotEmpty
        ? avatar
        : 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555245805&di=9eee289aff51c8925786add15309f736&imgtype=jpg&er=1&src=http%3A%2F%2Fimg5.hao123.com%2Fdata%2F1_42242836bf29aca0fb3dab75b4a9f9b6_510';
    this.nickname = nickname;
    return Auth();
  }
}
