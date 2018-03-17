import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart' as cons;

class Homepage extends StatefulWidget {
  @override
  HomepageState createState() => new HomepageState();
}

class HomepageState extends State<Homepage> {
  var data;
  int page = 1;

  Future<void> getData() async {
    var stickyPost = await http.get(
      Uri.encodeFull(cons.BASE_URL+"/posts?sticky=true&per_page=1")
    );
    var response = await http.get(
      Uri.encodeFull(cons.BASE_URL+
          "/posts?per_page=20&sticky=false&page="+page.toString()),
      headers: {
        "Accept": "application/json"
      }
    );

    this.setState(() {
      data == null ? data = JSON.decode(response.body) : data.addAll(JSON.decode(response.body));
      page++;
    });

    return null;
  }

  @override
  void initState() {
    this.getData();
  }

  String mildHtmlParse(String original) {
    return original.
    replaceAll("<p>", "").
    replaceAll("</p>", "").
    replaceAll("&#8217;", "'").
    replaceAll("&#8230;", "...").
    replaceAll("&#8220;", '"').
    replaceAll("&#8221;", '"');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {this.getData();},
        backgroundColor: Colors.grey,
        child: new Icon(Icons.add),
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          var title = mildHtmlParse(data[index]['title']['rendered']);
          var excerpt = mildHtmlParse(data[index]['excerpt']['rendered']);
          return new Card(
            child: new ListTile(
              title: new Text(title),
              subtitle: new Text(excerpt),
            )
          );
        }
      )
    );
  }
}