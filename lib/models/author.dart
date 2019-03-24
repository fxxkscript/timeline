class Author {
  int uid;
  String nickname;
  String avatar;

  Author(this.uid, this.nickname, this.avatar);

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(json['uid'], json['nickname'], json['avatar']);
  }
}
