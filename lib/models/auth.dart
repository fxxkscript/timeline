class Auth {
  final String mobile;
  final String token;
  Auth(this.mobile, this.token);

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(json['mobile'], json['token']);
  }
}
