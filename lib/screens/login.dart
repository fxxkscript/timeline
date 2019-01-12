import 'dart:ui';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:wshop/api/auth.dart';

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
  }

  @override
  void dispose() {
    focusNode.dispose();
    mobileController.dispose();

    super.dispose();
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
    }
  }

  void _getCode() {
    if (mobileController.text.isNotEmpty) {
      setState(() {
        _disabled = true;
        _count = timeout;

        getCode(mobileController.text);
        FocusScope.of(context).requestFocus(focusNode);
      });

      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _count--;
          _text = '获取验证码 (${_count})';
          if (_count == 0) {
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
        _isLoading ? CircularProgressIndicator() : loginBtn
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            child: loginForm,
            height: 300.0,
            width: 300.0,
          ),
        ),
      ),
    );
  }
}
