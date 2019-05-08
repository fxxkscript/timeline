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

class My {
  final Statis statis;
  final int invitationNum;
  final WithdrawCash withdrawCash;

  My({this.statis, this.invitationNum, this.withdrawCash});

  factory My.fromJson(Map<String, dynamic> json) {
    return new My(
        statis: Statis.fromJson(json['statis']),
        invitationNum: json['invitationNum'],
        withdrawCash: WithdrawCash.fromJson(json['withdrawCash']));
  }
}
