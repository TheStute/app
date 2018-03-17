import 'dart:async';
import 'dart:convert';

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

  Future<String> getData() async {
    var response = await http.get(
      Uri.encodeFull(cons.BASE_URL+
          "/posts?per_page=20&page="+
          page.toString()),
      headers: {
        "Accept": "application/json"
      }
    );

    this.setState(() {
      data == null ? data = JSON.decode(response.body) : data.addAll(JSON.decode(response.body));
      page++;
    });

    return "Done!";
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int index) {
        var title = data[index]['title']['rendered'];
        var excerpt = data[index]['excerpt']['rendered'];
        return new Card(
          child: new ListTile(
            title: new Text(title),
            subtitle: new Text(excerpt),
          )
        );
      },
    );
  }
}