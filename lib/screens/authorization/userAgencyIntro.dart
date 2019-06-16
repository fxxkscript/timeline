import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wshop/api/userAgencyIntro.dart';
import 'package:wshop/models/userAgencyIntro.dart';

class UserAgencyIntro extends StatefulWidget {
  UserAgencyIntro({Key key});

  @override
  State<StatefulWidget> createState() {
    return UserAgencyIntroState();
  }
}

class UserAgencyIntroState extends State<UserAgencyIntro> {
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
                            showToast("已复制到剪切板", textPadding: EdgeInsets.all(15));
                          },
                          borderSide: BorderSide(color: Colors.white),
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