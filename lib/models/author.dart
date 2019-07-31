class Author {
  int uid;
  String nickname;
  String avatar;

  Author(this.uid, this.nickname, this.avatar);

  factory Author.fromJson(Map<String, dynamic> json) {
    String avatar = 'http://img.ippapp.com/logo.png';

    if (json['avatar'] != null && json['avatar'].isNotEmpty) {
      avatar = json['avatar'];
    }

    return Author(
        json['uid'],
        json['nickname'],
        avatar
    );
}
