import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wshop/models/auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(children: [
        Column(
          children: <Widget>[
            Container(
              height: 236,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bg.png'), fit: BoxFit.cover)),
              child: Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        child: Image.network(Auth().avatar,
                            width: 70, height: 70, fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(Auth().nickname,
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(fontSize: 18)),
                      ),
                    ],
                  )),
            ),
            Container(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: '这一刻的想法...'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                      ],
                    ))),
          ],
        ),
        Positioned(
            left: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              width: MediaQuery.of(context).size.width,
              height: 42 + MediaQuery.of(context).padding.top,
              decoration:
                  BoxDecoration(color: Color.fromARGB(0, 237, 237, 237)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.navigate_before,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text('个人资料',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 17)),
                  ),
                  Expanded(
                    flex: 1,
                    child: ButtonTheme(
                        minWidth: 60,
                        height: 30,
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          child: const Text(
                            '完成',
                            style: TextStyle(color: Colors.white),
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                        )),
                  )
                ],
              ),
            ))
      ]),
    ));
  }
}
