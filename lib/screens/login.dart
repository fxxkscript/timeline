import 'dart:ui';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:wshop/api/auth.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  FocusNode focusNode;

  bool _isLoading = false;
  bool _disabled = true;
  int _count = 0;
  static const timeout = 60;

  String _mobile, _code, _text = '获取验证码';

  final formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  StreamSubscription handler;

  @override
  void initState() {
    super.initState();
    mobileController.addListener(() {
      if (mobileController.text.length == 11) {
        if (_count == 0) {
          setState(() {
            _disabled = false;
          });
        }
      } else {
        setState(() {
          _disabled = true;
        });
      }
    });
    focusNode = FocusNode();

    handler = fluwx.responseFromAuth.listen((response) async {
      print(response.code);
      setState(() => _isLoading = true);
      bool success = await loginByWechat(context, response.code);
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/', (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    mobileController.dispose();
    handler.cancel();

    super.dispose();
  }

  void _submit() async {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      bool success = await login(context, _mobile, _code);

      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/', (Route<dynamic> route) => false);
      }
    }
  }

  void _wechat() async {
    await fluwx.sendAuth(
        scope: "snsapi_userinfo", state: "wechat_sdk_demo_test");
  }

  void _getCode() {
    if (mobileController.text.isNotEmpty) {
      setState(() {
        _disabled = true;
        _count = timeout;

        getCode(context, mobileController.text);
        FocusScope.of(context).requestFocus(focusNode);
      });

      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _count--;
          _text = '获取验证码 ($_count)';
          if (_count == 0) {
            _text = '获取验证码';
            timer?.cancel();
            _disabled = false;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var loginBtn = Container(
        margin: const EdgeInsets.only(top: 13.0, left: 8, right: 8),
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: RaisedButton(
          onPressed: _submit,
          child: Text('登 录'),
          textColor: Colors.white,
          color: Colors.blue,
        ));

    var loginForm = Column(
      children: <Widget>[
        Text(
          '登录',
          textScaleFactor: 2.0,
        ),
        Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  onSaved: (val) => _mobile = val,
                  maxLength: 11,
                  validator: (val) {
                    return val.length != 11 ? "手机号不正确" : null;
                  },
                  decoration: InputDecoration(labelText: "手机号"),
                ),
              ),
              Stack(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        focusNode: focusNode,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        onSaved: (val) => _code = val,
                        validator: (val) {
                          return val.length != 4 ? "验证码格式不正确" : null;
                        },
                        decoration: InputDecoration(labelText: "验证码"),
                      )),
                  Positioned(
                      right: 8,
                      top: 20,
                      child: ButtonTheme(
                          minWidth: 30,
                          height: 20,
                          child: RaisedButton(
                            padding: const EdgeInsets.all(5),
                            onPressed: _disabled ? null : _getCode,
                            child: Text(_text, style: TextStyle(fontSize: 12)),
                            textColor: Colors.white,
                            color: Colors.blue,
                          ))),
                ],
              ),
            ],
          ),
        ),
        _isLoading ? CircularProgressIndicator() : loginBtn,
        Container(
            margin: const EdgeInsets.only(top: 13.0, left: 8, right: 8),
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: RaisedButton(
              onPressed: _wechat,
              child: Text('微信登录'),
              textColor: Colors.white,
              color: Colors.blue,
            ))
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            child: loginForm,
            height: 380.0,
            width: 300.0,
          ),
        ),
      ),
    );
  }
}
