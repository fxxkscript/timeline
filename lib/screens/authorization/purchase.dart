import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wshop/models/auth.dart';
import 'package:wshop/api/member.dart';
import 'package:wshop/models/purchase.dart';
import 'package:wshop/api/purchase.dart';
import 'package:oktoast/oktoast.dart';

class PurchaseScreen extends StatefulWidget {
  PurchaseScreen({Key key});

  @override
  State<StatefulWidget> createState() {
    return PurchaseState();
  }
}

class PurchaseState extends State<PurchaseScreen>
    with TickerProviderStateMixin {
  Future<List<Right>> _fetchRights;
  TabController _controller;

  @override
  void initState() {
    _fetchRights = fetchRights(context);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购买授权码'),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: FutureBuilder<List<Right>>(
          future: _fetchRights,
          builder: (BuildContext context, AsyncSnapshot<List<Right>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            _controller =
                TabController(length: snapshot.data.length, vsync: this);
            return Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(children: <Widget>[
                  UserInfoBrief(),
                  Container(height: 20),
                  TabBar(
                      controller: _controller,
                      tabs: snapshot.data
                          .map((right) => Tab(text: right.level.name))
                          .toList()),
                  Expanded(
                    child: TabBarView(
                        controller: _controller,
                        children: snapshot.data
                            .map((right) => _Content(right))
                            .toList()),
                  )
                ]));
          }),
    );
  }
}

class _Content extends StatelessWidget {
  final Right right;

  _Content(this.right);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            PriceCard(120),
            Container(height: 10),
            PurchaseButton('已有授权码，输入兑换 >', () async {
              // TODO: remove test code
              final code = await createActivation(context);
              print(code);
              _showPurchaseModal(context);
            }),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 30),
              child: Text('购买请联系客服',
                  style: TextStyle(fontSize: 12, color: Color(0xff666666))),
            ),
            _FeatureList(right.features)
          ],
        ),
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
    return RawMaterialButton(
        onPressed: onPressed,
        child: Container(
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

class _FeatureList extends StatelessWidget {
  final List<Feature> features;

  _FeatureList(this.features);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: features.map((item) => Text(item.name)).toList(),
    ));
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
                child: Image.network(Auth().avatar, fit: BoxFit.cover),
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
  final textController = TextEditingController();
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 300,
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(64.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '输入授权码',
                        fillColor: Color(0xFFF6F6F6),
                        filled: true),
                  ),
                  Container(height: 24),
                  PurchaseButton('确认兑换', () async {
                    if (textController.text.isEmpty) {
                      return;
                    }
                    String msg;
                    try {
                      await createMember(context, textController.text);
                      msg = '激活成功';
                      Navigator.pop(context);
                    } catch (e) {
                      msg = e.toString();
                    }
                    showToast(msg, textPadding: EdgeInsets.all(15));
                  }),
                ],
              ),
            ));
      });
}
