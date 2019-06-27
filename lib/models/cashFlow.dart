import 'package:wshop/utils/http_client.dart';

class CashFlow {
  int cursor = 0;
  int total;
  bool hasNext = true;
  final int pageSize = 20;
  final List<CashDetail> list = [];

  Future<CashFlow> fetchMore(context) {
    if (!hasNext) {
      return Future<CashFlow>(() {});
    }
    cursor += 1;
    return fetch(context);
  }

  Future<CashFlow> fetch(context) async {
    try {
      final response = await HttpClient().get(
          context,
          'trade/asset/findUserCashFlows',
          {"pageSize": pageSize, "cursor": cursor});
      List<CashDetail>.from(response['list']
          .map((item) => list.add(new CashDetail.fromJSON(item))));
      hasNext = response['hasNext'];
      return this;
    } catch (e) {
      print(e);
      return this;
    }
  }
}

class CashDetail {
  final int cashType;
  final String cashTypeName;
  final String payNo;
  final String createdAt;
  final String formatDealAmount;
  final String statusName;
  final String formatAfterAvailableAmount;

  CashDetail(
      {this.cashType,
      this.cashTypeName,
      this.payNo,
      this.createdAt,
      this.formatDealAmount,
      this.statusName,
      this.formatAfterAvailableAmount});

  factory CashDetail.fromJSON(Map<String, dynamic> json) {
    return CashDetail(
        cashType: json['cashType'],
        cashTypeName: json['cashTypeName'],
        payNo: json['payNo'],
        createdAt: json['createdAt'],
        formatDealAmount: json['formatDealAmount'],
        statusName: json['statusName'],
        formatAfterAvailableAmount: json['formatAfterAvailableAmount']);
  }
}

class CashWithdraw extends CashDetail {}

class CashCommission extends CashDetail {}
