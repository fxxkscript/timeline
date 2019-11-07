import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wshop/api/purchase.dart';
import 'package:wshop/components/PurchaseModal.dart';
import 'package:wshop/components/PurchaseTabIndicator.dart';
import 'package:wshop/models/auth.dart';
import 'package:wshop/models/purchase.dart';

class PurchaseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PurchaseState();
  }
}

class PurchaseState extends State<PurchaseScreen>
    with TickerProviderStateMixin {
  Future<List<Right>> _fetchRights;
  TabController _controller;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  String _queryProductError = null;

  @override
  void initState() {
    Stream purchaseUpdates = _connection.purchaseUpdatedStream;

    _subscription = purchaseUpdates.listen((purchases) {
      _listenToPurchaseUpdated(purchases);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });

    _fetchRights = fetchRights();

    initStoreInfo();
    super.initState();
  }

  void initStoreInfo() async {
    var list = await _fetchRights;

    final bool available = await _connection.isAvailable();
    if (!available) {
      setState(() {
        _isAvailable = available;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _purchasePending = false;
      });
      return;
      // The store cannot be reached or accessed. Update the UI accordingly.
    }

    final ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(list.map((item) {
      return item.levelGoods.appleGoodsId;
    }).toSet());

    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = available;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = available;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
        await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }

    setState(() {
      _isAvailable = available;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.verificationData == null) {
      await _connection.refreshPurchaseVerificationData();
    }
    return verify(purchaseDetails.purchaseID, purchaseDetails.productID,
        purchaseDetails.verificationData);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
          }
        }
        if (Platform.isIOS) {
          InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
    showToast('非法购买');
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    });
    // @TODO refresh user data
    showToast('购买成功');
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  ProductDetails getProductDetail(Right right) {
    if (_products == null) {
      return null;
    }
    var product = _products.firstWhere(
        (product) => product.id == right.levelGoods.appleGoodsId,
        orElse: () => null);
    return product;
  }

  @override
  void dispose() {
    _subscription.cancel();
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
                  Container(
                      color: Color(0xfff6f6f6),
                      child: TabBar(
                          controller: _controller,
                          indicator: PurchaseTabIndicator(),
                          tabs: snapshot.data
                              .map((right) => Tab(
                                    child: Row(
                                      children: <Widget>[
                                        right.level.icon.isEmpty
                                            ? Container()
                                            : Image.network(right.level.icon,
                                                width: 16, height: 16),
                                        Container(width: 4),
                                        Text(right.level.name,
                                            style: TextStyle(
                                                color: Color(0xff333333))),
                                      ],
                                    ),
                                  ))
                              .toList())),
                  Expanded(
                    child: TabBarView(
                        controller: _controller,
                        children: snapshot.data
                            .map((right) => _Content(right,
                                getProductDetail(right), _purchasePending))
                            .toList()),
                  )
                ]));
          }),
    );
  }
}

class _Content extends StatelessWidget {
  final Right right;
  final ProductDetails product;
  final bool purchasePending;

  _Content(this.right, this.product, this.purchasePending);

  @override
  Widget build(BuildContext context) {
    String text = '购买';
    bool available = false;

    if (purchasePending) {
      text = '购买中...';
    }

    if (product != null) {
      available = true;
    }

    if (purchasePending) {
      available = false;
    }

    Widget button;
    if (Platform.isIOS) {
      button = PurchaseButton(text, () async {
        final PurchaseParam purchaseParam =
            PurchaseParam(productDetails: product);
        print(product.description);
        InAppPurchaseConnection.instance
            .buyNonConsumable(purchaseParam: purchaseParam);
      }, available);
    } else {
      button = Text('请联系客服购买授权码');
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            PriceCard(right.levelGoods),
            Container(height: 10),
            button,
            Padding(padding: const EdgeInsets.only(top: 5.0, bottom: 60)),
            _FeatureList(right.level.name, right.features)
          ],
        ),
      ),
    );
  }
}

class PriceCard extends StatelessWidget {
  final LevelGoods levelGoods;

  PriceCard(this.levelGoods);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        Image.asset('assets/price_bg.png', fit: BoxFit.contain, width: 300),
        DefaultTextStyle(
          style: TextStyle(color: Color(0xFFFCEAB8)),
          child: Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${levelGoods.typeName}⋅${levelGoods.days}天',
                      style: TextStyle(fontSize: 15)),
                  Container(height: 5),
                  Row(
                      children: <Widget>[
                        Text('￥', style: TextStyle(fontSize: 18)),
                        Text(levelGoods.price, style: TextStyle(fontSize: 48)),
                        Container(width: 5),
                        Text(
                            '${levelGoods.perPrice}元/${levelGoods.perUnitName}',
                            style: TextStyle(fontSize: 13))
                      ],
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic),
                ],
              ),
              left: 60,
              top: 45),
        ),
      ],
    ));
  }
}

class _FeatureList extends StatelessWidget {
  final List<Feature> features;
  final String title;

  _FeatureList(this.title, this.features);

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      Container(
        padding: EdgeInsets.only(top: 20),
        height: 170,
        child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 5,
            childAspectRatio: 1.8,
            children: features
                .map((item) => GridTile(
                        child: Container(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.network(item.icon, width: 31, height: 31),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(item.name,
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                            Spacer(),
                            Text(
                              item.desc,
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff999999)),
                            )
                          ]),
                    )))
                .toList()),
      )
    ];
    items.insert(
        0,
        Text('${this.title}特权',
            style: Theme.of(context)
                .textTheme
                .headline
                .copyWith(fontWeight: FontWeight.bold)));
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
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
