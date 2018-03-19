import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart' as cons;

class Article extends StatefulWidget {
  final String postID;

  Article(this.postID);

  @override
  ArticleState createState() => new ArticleState(postID);
}

class ArticleState extends State<Article> {
  final String postID;
  ArticleState(this.postID);

  var data;

  String title = "Loading...";

  Future<void> getData() async {
    var response = await http.get(
      Uri.encodeFull(cons.BASE_URL+"/posts/"+postID),
      headers: {
        "Accept": "application/json"
      }
    );
    this.setState(() {
      data = JSON.decode(response.body);
      title = data["title"]["rendered"];
    });

    return null;
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar (
        title: new Text(cons.mildHtmlParse(title)),
        centerTitle: true,
      ),
      body: new ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: data == null ? <Widget>[new Text("Loading...")] :
              <Widget>[
                new Text(data["featured_media"].toString()),
                new Text(data["author"].toString()),
                new Text(DateTime.parse(data["date"]).toString()),
                new Text(data["content"]["rendered"])
              ],
          );
        }
      )
    );
  }
}
