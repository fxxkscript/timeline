import 'package:flutter/material.dart';

class MyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.red,
      body: new Container(
        child: new Center(
          child: new Column(
            // center the children
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
                Icons.favorite,
                size: 160.0,
                color: Colors.white,
              ),
              new Text(
                "second Tab",
                style: new TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}