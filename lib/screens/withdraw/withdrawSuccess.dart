import 'package:flutter/material.dart';
import 'package:wshop/models/withdraw.dart';

class WithdrawSuccessModal extends StatelessWidget {
  final UserAsset userAsset;
  final double withdrawMoney;

  WithdrawSuccessModal(this.userAsset, this.withdrawMoney);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/success_icon.png',
                scale: 2,
              ),
              Container(
                height: 20,
              ),
              const Text('提现成功'),
              Container(
                height: 30,
              ),
              Text('￥${withdrawMoney.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 36, color: Color(0xFF131313))),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Container(
                width: 160,
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    '完成',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
