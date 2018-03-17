import 'package:flutter/material.dart';

import 'homepage.dart' as homepage;
import 'subpage.dart' as subpage;
import 'setpage.dart' as setpage;

void main() => runApp(new MainApp());

class MainApp extends StatefulWidget {
  @override
  MainAppState createState() => new MainAppState();
}

class MainAppState extends State<MainApp> {
  var mainpage = new homepage.Homepage();
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("The Stute"),
        ),
        body: mainpage
      )
    );
  }
}
