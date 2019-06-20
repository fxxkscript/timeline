import 'package:flutter/material.dart';
import 'package:wshop/models/withdraw.dart';

class WithdrawSuccessModal extends StatelessWidget {
  final UserAsset userAsset;

  WithdrawSuccessModal(this.userAsset);

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
              Container(),
              Text('提现成功'),
              Text('￥8733.00'),
              FlatButton(
                onPressed: () {},
                child: Text('完成'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
