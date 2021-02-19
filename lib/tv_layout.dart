import 'package:flutter/material.dart';
import 'package:movie/search.dart';

class TVLayout extends StatefulWidget{
  @override
  TVLayoutState createState() => TVLayoutState();
}

class TVLayoutState extends State<TVLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("TV Show"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => SearchLayout()));
          }),
        ],
        bottom: TabBar(tabs: null),
      ),
    );
  }
}