class UserAsset {
  final double amount;
  final double availableAmount;
  final double frozenAmount;

  UserAsset({this.amount, this.availableAmount, this.frozenAmount});

  factory UserAsset.fromJson(Map<String, dynamic> json) {
    return new UserAsset(
      amount: json['amount'].toDouble(),
      availableAmount: json['availableAmount'].toDouble(),
      frozenAmount: json['frozenAmount'].toDouble(),
    );
  }
}
