import 'dart:ui';

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _username, _password;

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
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
                  keyboardType: TextInputType.phone,
                  onSaved: (val) => _username = val,
                  validator: (val) {
                    return val.length != 11 ? "手机号不正确" : null;
                  },
                  decoration: InputDecoration(labelText: "手机号"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onSaved: (val) => _password = val,
                  validator: (val) {
                    return val.length != 4 ? "验证码格式不正确" : null;
                  },
                  decoration: InputDecoration(labelText: "验证码"),
                ),
              ),
            ],
          ),
        ),
        _isLoading ? CircularProgressIndicator() : loginBtn
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: Container(
        child: Center(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                child: loginForm,
                height: 300.0,
                width: 300.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
