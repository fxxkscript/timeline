import 'package:flutter/material.dart';


class Contacts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactsState();
  }
}

class ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: <Widget>[
          new Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.only(top: 10.0),
            child: new Container(
              child: new ListTile(
                title: new Text('新的朋友'),
                leading: new Icon(Icons.add),
              ),
              height: 50.0,
              color: Colors.white,
            ),
          ),
          new Container(
            child: new ListTile(
              title: new Text('群聊'),
              leading: new Icon(Icons.group),
            ),
            height: 50.0,
            color: Colors.white,
          ),
          new Container(
            child: new ListTile(
              title: new Text('标签'),
              leading: new Icon(Icons.label),
            ),
            height: 50.0,
            color: Colors.white,
          ),
          new Container(
            child: new ListTile(
              title: new Text('公众号'),
              leading: new Icon(Icons.person),
            ),
            height: 50.0,
            color: Colors.white,
          ),
          new Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.only(top: 20.0),
            child: new Container(
              child: new ListTile(
                title: new Text('阿panda'),
              ),
              height: 50.0,
              color: Colors.white,
            ),
          )
        ]
      )
    );
  }
}
