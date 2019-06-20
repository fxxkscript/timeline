import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wshop/api/userAgencyIntro.dart';
import 'package:wshop/models/userAgencyIntro.dart';
import 'package:wshop/components/PurchaseModal.dart';

class UserAgencyIntroScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserAgencyIntroScreenState();
  }
}

class UserAgencyIntroScreenState extends State<UserAgencyIntroScreen> {
  Future<UserAgencyIntroData> _fetchData;

  @override
  void initState() {
    super.initState();
    _fetchData = fetchUserAgencyIntro(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserAgencyIntroData>(
      future: _fetchData,
      builder:
          (BuildContext context, AsyncSnapshot<UserAgencyIntroData> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Image.asset(
                "assets/user_intro_bg.png",
                fit: BoxFit.cover,
                height: 300,
                alignment: Alignment.topCenter,
              ),
              Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    title: Text('邀请好友'),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    textTheme: TextTheme(
                        title: TextStyle(color: Colors.white, fontSize: 17)),
                    iconTheme: IconThemeData(
                      color: Colors.white,
                    ),
                  ),
                  body: DefaultTextStyle(
                    style: TextStyle(color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        Text("邀请码"),
                        Container(height: 5),
                        Text(
                          snapshot.data.invitationCode,
                          style: TextStyle(fontSize: 32),
                        ),
                        Text(
                          "新用户输入你的邀请码，你即可获收益。",
                          style: TextStyle(fontSize: 12),
                        ),
                        Container(height: 10),
                        OutlineButton(
                          child: Text(
                            "复制",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Clipboard.setData(new ClipboardData(
                                text: snapshot.data.invitationCode));
                            showToast("已复制到剪切板",
                                textPadding: EdgeInsets.all(15));
                          },
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        _OverviewBlock(
                          invitationNum: snapshot.data.invitationNum,
                          commission: snapshot.data.commission,
                        ),
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: GestureDetector(
                                onTap: () {
                                  showPurchaseModal(
                                      context, '输入邀请码', '确认', invitedByCode);
                                },
                                child: Text('输入邀请码',
                                    style: TextStyle(
                                        color: Color(0xFF0CC160),
                                        fontSize: 16)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        );
      },
    );
  }
}

class _OverviewBlock extends StatelessWidget {
  final String commission;
  final int invitationNum;

  _OverviewBlock({this.commission, this.invitationNum});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18),
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(const Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
              color: Color(0x88000000),
              blurRadius: 2.0,
              offset: Offset(
                0.0,
                1.0,
              ),
            )
          ],
        ),
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _OverviewItem(this.commission, "返佣金额"),
            Container(
              width: 1,
              height: 40,
              color: Color(0xFFE5E5E5),
            ),
            _OverviewItem(this.invitationNum.toString(), "累计邀请人数"),
          ],
        ),
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String upper;
  final String bottom;

  _OverviewItem(this.upper, this.bottom);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(this.upper,
            style: TextStyle(
                color: Color(0xFF131313),
                fontWeight: FontWeight.w600,
                fontSize: 24)),
        Text(this.bottom,
            style: TextStyle(color: Color(0xFFACACAC), fontSize: 12)),
      ],
    );
  }
}
