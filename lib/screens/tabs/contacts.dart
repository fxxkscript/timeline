import 'package:flutter/material.dart';

class Contacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset('assets/header.png'),
                Container(
                  width: 100,
                  height: 100,
                  child: Text('超级无敌坑比🐂', style: TextStyle(color: Colors.blue)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
