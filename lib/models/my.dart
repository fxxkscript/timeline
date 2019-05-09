class Statis {
  int news;
  int tweets;
  int friends;
  int followers;

  Statis({this.news, this.tweets, this.friends, this.followers});

  factory Statis.fromJson(Map<String, dynamic> json) {
    return new Statis(
        news: json['news'],
        tweets: json['tweets'],
        friends: json['friends'],
        followers: json['followers']);
  }
}

class WithdrawCash {
  int canWithdrawMoney;
  int withdrawnMoney;

  WithdrawCash({this.canWithdrawMoney, this.withdrawnMoney});

  factory WithdrawCash.fromJson(Map<String, dynamic> json) {
    return new WithdrawCash(
        canWithdrawMoney: json['canWithdrawMoney'],
        withdrawnMoney: json['withdrawnMoney']);
  }
}

class User {
  int uid;
  String mobile;
  String nickname;
  int gender;
  String avatar;

  User({this.uid, this.mobile, this.nickname, this.gender, this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
        uid: json['uid'],
        mobile: json['mobile'],
        nickname: json['nickname'],
        gender: json['gender'],
        avatar: json['avatar']);
  }
}

class My {
  final Statis statis;
  final int invitationNum;
  final WithdrawCash withdrawCash;
  final User user;

  My({this.statis, this.invitationNum, this.withdrawCash, this.user});

  factory My.fromJson(Map<String, dynamic> json) {
    return new My(
        statis: Statis.fromJson(json['statis']),
        invitationNum: json['invitationNum'],
        withdrawCash: WithdrawCash.fromJson(json['withdrawCash']),
        user: User.fromJson(json['user']));
  }
}
