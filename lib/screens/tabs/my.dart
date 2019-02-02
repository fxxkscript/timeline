import 'package:flutter/material.dart';

class MyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            padding:const EdgeInsets.only(top: 20.0),
            child: Container(
              height: 80.0,
              child: ListTile(
                leading: Image.network(
                            'https://ws2.sinaimg.cn/large/006tNc79gy1fyt6bakq3mj30rs15ojvs.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover),
                title: Text("Tony"),
                subtitle: Text("微信号：ty001"),
                trailing: Icon(Icons.fullscreen),
                onTap: (){

                },
              ),
              color: Colors.white,
            ),
            color: Colors.grey[200],
          ),
          Container(
            padding:const EdgeInsets.only(top: 20.0),
            child: Container(
              child: ListTile(
                leading: Icon(Icons.call_to_action),
                title: Text("钱包"),
                onTap: (){

                },
              ),
              color: Colors.white,
              height: 50.0,
            ),
            color: Colors.grey[200],
          ),
          Container(
            padding:const EdgeInsets.only(top: 20.0),
            child: Container(
              child: ListTile(
                leading: Icon(Icons.dashboard),
                title: Text("收藏"),
              ),
              color: Colors.white,
              height: 50.0,
            ),
            color: Colors.grey[200],
          ),
          Container(
            child: ListTile(
              leading: Icon(Icons.photo),
              title: Text("相册"),
            ),
            color: Colors.white,
            height: 50.0,
          ),
          Container(
            child: ListTile(
              leading: Icon(Icons.credit_card),
              title: Text("卡包"),
            ),
            color: Colors.white,
            height: 50.0,
          ),
          Container(
            child: ListTile(
              leading: Icon(Icons.tag_faces),
              title: Text("表情"),
            ),
            color: Colors.white,
            height: 50.0,
          ),
          Container(
            padding:const EdgeInsets.only(top: 20.0),
            child: Container(
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text("设置"),
              ),
              color: Colors.white,
              height: 50.0,
            ),
            color: Colors.grey[200],
          ),
        ],
      )
    );
  }
}
