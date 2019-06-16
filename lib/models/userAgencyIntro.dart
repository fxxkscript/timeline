class UserAgencyIntroData {
  final String invitationCode;
  final int invitationNum;
  final String commission;

  UserAgencyIntroData({this.invitationCode, this.invitationNum, this.commission});

  factory UserAgencyIntroData.fromJson(Map<String, dynamic> json) {
    return new UserAgencyIntroData(
        invitationCode: json['invitationCode']['code'],
        invitationNum: json['invitationStatic']['invitationNum'],
        commission: json['invitationStatic']['commission'],);
  }
}
