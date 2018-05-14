import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart' as cons;
import 'article.dart' show Article;

class Homepage extends StatefulWidget {
  @override
  HomepageState createState() => new HomepageState();
}

class HomepageState extends State<Homepage> {
  var data;
  int page = 1;

  Future<void> getData() async {
    var stickyPost;
    if(page == 1)
      stickyPost = await http.get(
        Uri.encodeFull(cons.BASE_URL+"/posts?sticky=true&per_page=1"),
        headers: {
          "Accept": "application/json"
        }
      );
    var response = await http.get(
      Uri.encodeFull(cons.BASE_URL+"/posts?per_page=20&sticky=false&page="+page.toString()),
      headers: {
        "Accept": "application/json"
      }
    );

    this.setState(() {
      if(stickyPost != null) {
        data = JSON.decode(stickyPost.body);
      }
      data.addAll(JSON.decode(response.body));
      page++;
    });

    return null;
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return new Scaffold(
      floatingActionButton: new FloatingActionButton (
        onPressed: () {this.getData();},
        backgroundColor: Colors.grey,
        child: new Icon(Icons.add),
      ),
      body: data == null ? new Center(child: new CircularProgressIndicator()) :
      new ListView.builder(
        itemCount: data.length,
        controller: controller,
        itemBuilder: (BuildContext context, int index) {
          var title = cons.mildHtmlParse(data[index]['title']['rendered']);
          var excerpt = cons.mildHtmlParse(data[index]['excerpt']['rendered']);
          if(index == 0){
            return new FlatButton (
              child: new Card(
                child: new ListTile(
                  title: new Text(title),
                  subtitle: new Text(excerpt),
                  leading: new Icon(Icons.featured_video),
                )
              ),
              onPressed: (){Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Article(data[index]['id'].toString())));},
            );
          }
          else{
            return new FlatButton (
              child: new Card (
                child: new ListTile (
                  title: new Text (title),
                  subtitle: new Text (excerpt),
                )
              ),
              onPressed: (){Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Article(data[index]['id'].toString())));},
            );
          }
        }
      )
    );
  }
}