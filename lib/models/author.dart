class Author {
  int uid;
  String nickname;
  String avatar;

  Author(this.uid, this.nickname, this.avatar);

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
        json['uid'],
        json['nickname'],
        json['avatar'].isNotEmpty
            ? json['avatar']
            : 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555245805&di=9eee289aff51c8925786add15309f736&imgtype=jpg&er=1&src=http%3A%2F%2Fimg5.hao123.com%2Fdata%2F1_42242836bf29aca0fb3dab75b4a9f9b6_510');
  }
}
