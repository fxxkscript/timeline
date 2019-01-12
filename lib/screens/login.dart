import 'dart:ui';
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
  String _mobile, _code;

  final formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    var loginBtn = RaisedButton(
      onPressed: _submit,
      child: Text("登录"),
    );
    var loginForm = Column(
      children: <Widget>[
        Text(
          "登录",
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
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      TextFormField(
                        focusNode: focusNode,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        onSaved: (val) => _code = val,
                        validator: (val) {
                          return val.length != 4 ? "验证码格式不正确" : null;
                        },
                        decoration: InputDecoration(labelText: "验证码"),
                      ),
                      Positioned(
                          right: 0,
                          top: 10,
                          child: RaisedButton(
                            onPressed: () {
                              if (mobileController.text.isNotEmpty) {
                                print(mobileController.text);
                                getCode(mobileController.text);
                              }
                              FocusScope.of(context).requestFocus(focusNode);
                            },
                            child: Text('获取验证码'),
                          )),
                    ],
                  )),
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
