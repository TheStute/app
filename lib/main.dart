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
  Widget mainpage = new homepage.Homepage();
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("The Stute"),
        ),
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              new DrawerHeader(child: null),
              new ListTile(
                title: new Text("Home"),
                onTap: (){
                  print("HOME");
                  this.setState((){
                    mainpage = homepage.Homepage();
                  });
                  Navigator.pop(context);
                },
                leading: new Icon(Icons.home),
              ),
              new ListTile(
                title: new Text("Subscriptions"),
                onTap: (){
                  print("SUBS");
                  Navigator.pop(context);
                },
                leading: new Icon(Icons.mail),
              ),
              new ListTile(
                title: new Text("Settings"),
                onTap: (){
                  print("SETS");
                  this.setState((){
                    mainpage = setpage.Setpage();
                  });
                  Navigator.pop(context);
                },
                leading: new Icon(Icons.settings),
              ),
            ],
          ),
        ),
        body: mainpage,
      ),
      theme: new ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black
      ),
    );
  }
}
