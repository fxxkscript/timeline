import 'package:flutter/material.dart';
import 'fundDetail.dart';

class FundFlowScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FundFlowScreenState();
  }
}

const list = [{}, {}, {}];

class FundFlowScreenState extends State<FundFlowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('资金明细'),
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: ListView.separated(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return fundItem();
          },
          separatorBuilder: (context, index) {
            return Container(
                color: Colors.white, child: Divider(height: 1, indent: 16.0));
          },
        ));
  }

  Widget fundItem() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FundDetail()));
      },
      child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('返佣'),
                      Text('+ 5.00'),
                    ]),
                Container(height: 8),
                DefaultTextStyle(
                  style: TextStyle(fontSize: 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('2019-02-19 09:00:00',
                            style: TextStyle(color: Color(0xFFACACAC))),
                        Text('处理中',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      ]),
                )
              ],
            ),
          )),
    );
  }
}
