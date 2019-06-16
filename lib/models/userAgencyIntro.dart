class UserAgencyIntroData {
  final String invitationCode;
  final int invitationNum;

  UserAgencyIntroData({ this.invitationCode, this.invitationNum });

  factory UserAgencyIntroData.fromJson(Map<String, dynamic> json) {
    return new UserAgencyIntroData(
      invitationCode: json['invitationCode']['code'],
      invitationNum: json['invitationStatic']['invitationNum']
    );
  }
}