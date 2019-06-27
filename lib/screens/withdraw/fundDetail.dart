import 'package:flutter/material.dart';
import 'package:wshop/models/cashFlow.dart';

class FundDetail extends StatefulWidget {
  final CashDetail cashDetail;

  FundDetail(this.cashDetail);

  @override
  State<StatefulWidget> createState() {
    return FundDetailState(cashDetail);
  }
}

class FundDetailState extends State<FundDetail> {
  final CashDetail cashDetail;

  FundDetailState(this.cashDetail);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('提现'),
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              runSpacing: 6,
              children: <Widget>[
                rowItem(
                    '交易金额', Text(cashDetail.formatDealAmount, style: TextStyle(fontSize: 36))),
                rowItem(
                    '',
                    Text(cashDetail.statusName,
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor))),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 0.5, indent: 16),
                ),
                rowItem('类型', cashDetail.cashTypeName),
                rowItem('时间', cashDetail.createdAt),
                rowItem('交易单号', cashDetail.payNo),
                rowItem('剩余金额', cashDetail.formatAfterAvailableAmount),
              ],
            ),
          ),
        ));
  }

  Widget rowItem(String ltString, rt) {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 14, color: Color(0xFF131313)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(ltString),
              rt is String
                  ? Text(rt, style: TextStyle(color: Color(0xFFACACAC)))
                  : rt
            ]),
      ),
    );
  }
}
