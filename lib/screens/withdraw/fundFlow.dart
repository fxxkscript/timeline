import 'package:flutter/material.dart';
import 'package:wshop/models/cashFlow.dart';
import 'fundDetail.dart';

class FundFlowScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FundFlowScreenState();
  }
}

class FundFlowScreenState extends State<FundFlowScreen> {
  ScrollController _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  final CashFlow _cashFlow = CashFlow();

  Future<CashFlow> _fetchCashFlow;

  @override
  void initState() {
    _controller.addListener(() {
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd)
        setState(() {
          _fetchCashFlow = _cashFlow.fetchMore(context);
        });
    });

    _fetchCashFlow = _cashFlow.fetch(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('资金明细'),
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: FutureBuilder(
          future: _fetchCashFlow,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: new CircularProgressIndicator());
            }
            return ListView.separated(
              itemCount: _cashFlow.list.length,
              itemBuilder: (context, index) {
                return fundItem(_cashFlow.list[index]);
              },
              separatorBuilder: (context, index) {
                return Container(
                    color: Colors.white,
                    child: Divider(height: 1, indent: 16.0));
              },
            );
          },
        ));
  }

  Widget fundItem(CashDetail cashDetail) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FundDetail(cashDetail)));
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
                      Text(cashDetail.cashTypeName),
                      Text(cashDetail.formatDealAmount),
                    ]),
                Container(height: 8),
                DefaultTextStyle(
                  style: TextStyle(fontSize: 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(cashDetail.createdAt,
                            style: TextStyle(color: Color(0xFFACACAC))),
                        Text(cashDetail.statusName,
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
