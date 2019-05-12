class Profile {
  final String mobile;
  final String avatar;
  final String nickname;

  Profile({this.mobile, this.avatar, this.nickname});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return new Profile(
        mobile: json['mobile'],
        avatar: json['avatar'],
        nickname: json['nickname']
    );
  }
}
