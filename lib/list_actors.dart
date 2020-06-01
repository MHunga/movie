import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'details_actor.dart';
class ListActor extends StatefulWidget{
  final String passData;
  const ListActor({Key key, this.passData}) : super(key: key);
  @override
  ListActorState createState() => ListActorState();
}

class ListActorState extends State<ListActor> {
  List data;
  String baseUrl = "https://api.themoviedb.org/3/movie/";
  String apikey = "/credits?api_key=9bb89316d8693b06d7a84980b29c011f";
  @override
  void initState() {
    super.initState();
    this.getCastMovies();
  }

  @override
  void dispose() {
    super.dispose();
  }
  Future<String> getCastMovies() async {
    var response = await http.get(
        Uri.encodeFull(baseUrl + widget.passData+ apikey),
        headers: {"Accept": "application/json"});
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      print("$convertDataToJson");
      data = convertDataToJson['cast'];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: lisviewBuilder,
      itemCount: 6,
      scrollDirection: Axis.horizontal,);
  }

  Widget lisviewBuilder(BuildContext context, int index) {
    if (data == null||(data.isEmpty)) {
      return Container(width: 120,child: Card(elevation: 5.0,child: Image.network("https://www.pngitem.com/pimgs/m/30-307416_profile-icon-png-image-free-download-searchpng-employee.png")),);
    } else {
      if(data[index]['profile_path']==null)
        return Card(elevation: 5.0,);
      else{
        return InkWell(
          onTap: (){
            Navigator.push(context,  MaterialPageRoute(builder: (context) => DetailsActor(profilePath: 'https://image.tmdb.org/t/p/original'+ data[index]['profile_path'],
            name: data[index]['name'],)));
          },
          child: Card(
              elevation: 5.0,
              child: Container(
                width: 120,
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/original'+ data[index]['profile_path'],height: 130,
                      ),
                    ),
                    AutoSizeText(data[index]['name'], style: TextStyle(fontWeight: FontWeight.w800,color: Colors.grey[900]),
                    maxLines: 1,),
                    AutoSizeText(data[index]['character'], style: TextStyle(fontWeight: FontWeight.w300,color: Colors.grey[900],fontSize: 10,)
                      ,maxLines: 1,minFontSize: 8,)
                  ],
                ),
              )
          ),
        );
      }
    }
  }
}