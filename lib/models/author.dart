class Author {
  final int uid;
  final String nickname;
  final String avatar;

  const Author(this.uid, this.nickname, this.avatar);

  factory Author.fromJson(Map<String, dynamic> json) {
    String avatar = 'http://img.ippapp.com/logo.png';

    if (json['avatar'] != null && json['avatar'].isNotEmpty) {
      avatar = json['avatar'];
    }

    return Author(json['uid'], json['nickname'], avatar);
  }
}
