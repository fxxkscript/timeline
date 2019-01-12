import 'package:flutter/material.dart';
import 'package:wshop/screens/tabs/my.dart';
import 'package:wshop/screens/tabs/timeline.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("相册"),
      ),
      body: TabBarView(
        // Add tabs as widgets
        children: <Widget>[TimelineTab(), MyTab()],
        // set the controller
        controller: controller,
      ),
      bottomNavigationBar: Material(
        // set the color of the bottom navigation bar
        color: Colors.blue,
        // set the tab bar as the child of bottom navigation bar
        child: TabBar(
          tabs: <Tab>[
            Tab(
              text: "朋友圈",
            ),
            Tab(
              text: "我",
            )
          ],
          // setup the controller
          controller: controller,
        ),
      ),
    );
  }
}
