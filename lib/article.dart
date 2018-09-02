import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html_view/flutter_html_view.dart';

import 'constants.dart' as cons;

String formatDate(DateTime date) {
  var formattedString = "";
  List<String> months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  formattedString = formattedString+months[date.month];
  formattedString = formattedString+" "+date.day.toString()+", "+date.year.toString();
  return formattedString;
}

TextStyle authorStyle = new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.black, height: 1.2);
TextStyle articleStyle = new TextStyle(fontSize: 18.0, color: Colors.black, height: 1.2, wordSpacing: 1.1);

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
    var headers = { "Accept": "applications/json" };
    var response = await http.get(
      Uri.encodeFull(cons.BASE_URL+"/posts/"+postID),
      headers: headers
    );
    var baseData = json.decode(response.body);
    response = await http.get(
      Uri.encodeFull(baseData["_links"]["author"][0]["href"].toString()),
      headers: headers
    );
    baseData["author"] = json.decode(response.body)["name"];
    response = await http.get(
      Uri.encodeFull(baseData["_links"]["wp:featuredmedia"][0]["href"].toString()),
      headers: headers
    );
    baseData["featured_media"] = json.decode(response.body)["guid"]["rendered"];
    this.setState(() {
      data = baseData;
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
                FadeInImage.assetNetwork(placeholder: "assets/loading.gif", image: data["featured_media"].toString()),
                new Text(formatDate(DateTime.parse(data["date"])), style: authorStyle),
                new Text("By: "+data["author"].toString(), style: authorStyle),
                new DefaultTextStyle(
                    style: articleStyle,
                    child: new HtmlView(data: data["content"]["rendered"])
                )
              ],
          );
        }
      )
    );
  }
}
