import 'package:flutter/material.dart';
import 'package:wshop/models/auth.dart';

class PurchaseScreen extends StatefulWidget {
  PurchaseScreen({Key key});

  @override
  State<StatefulWidget> createState() {
    return PurchaseState();
  }
}

class PurchaseState extends State<PurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购买授权码'),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(children: <Widget>[UserInfoBrief(), new _Body()])),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          PriceCard(120),
          PurchaseButton('已有授权码，输入兑换 >', () {
            _showPurchaseModal(context);
          }),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text('购买请联系客服',
                style: TextStyle(fontSize: 12, color: Color(0xff666666))),
          )
        ],
      ),
    );
  }
}

class PriceCard extends StatelessWidget {
  final int price;

  PriceCard(this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        Image.asset(
          'assets/price_bg.png',
          fit: BoxFit.contain,
        ),
        Positioned(
            child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(price.toString(),
                        style:
                            TextStyle(color: Color(0xFFFCEAB8), fontSize: 48)),
                  ),
                  Text('${(price / 12)}元/月',
                      style: TextStyle(color: Color(0xFFFCEAB8), fontSize: 13))
                ],
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic),
            left: 65,
            bottom: 28),
      ],
    ));
  }
}

class PurchaseButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  PurchaseButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: onPressed,
        child: Container(
            width: 311,
            height: 44,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 65, 61, 62),
                  Color.fromARGB(255, 27, 25, 26)
                ])),
            child: Center(
                child: Text(text,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 252, 234, 184))))));
  }
}

class UserInfoBrief extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ClipRRect(
              child: Container(
                width: 44,
                height: 44,
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 248, 248, 248)),
                child: Image.network(Auth().avatar, fit: BoxFit.contain),
              ),
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Auth().nickname,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text(
                    '当前尚未开通会员',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(fontSize: 12),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

_showPurchaseModal(context) {
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(height: 200, child: Column(
            children: <Widget>[
              TextField(),
              PurchaseButton('确认兑换', () {}),
            ],
          )),
        );
      });
}
