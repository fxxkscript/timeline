import 'package:flutter/material.dart';

class FundDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FundDetailState();
  }
}

class FundDetailState extends State<FundDetail> {
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
                    '交易金额', Text('-405.87', style: TextStyle(fontSize: 36))),
                rowItem(
                    '',
                    Text('交易失败',
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor))),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 0.5, indent: 16),
                ),
                rowItem('类型', '提现'),
                rowItem('时间', '2019-02-19 09:00:00'),
                rowItem('交易单号', '3865476587657867486237657856'),
                rowItem('剩余金额', '405.94'),
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
