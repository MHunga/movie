import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/details_movie.dart';
import 'package:movie/search_movie.dart';

class SearchLayout extends StatefulWidget{
  @override
  SearchLayoutState createState() => SearchLayoutState();

}

class SearchLayoutState extends State<SearchLayout> {
List<SearchMovie> listMovie = List<SearchMovie>();
  String baseUrl = "https://api.themoviedb.org/3/search/movie";
  String apikey = "?api_key=9bb89316d8693b06d7a84980b29c011f";
final SearchBarController<SearchMovie> _searchBarController = SearchBarController();
bool isReplay = false;
  @override
  void dispose() {
    super.dispose();
  }
  Future<List<SearchMovie>> getSearchMovies(String text) async {
    var response = await http.get(
        Uri.encodeFull(baseUrl + apikey+ "&query="+text),
        headers: {"Accept": "application/json"});
    var list = List<SearchMovie>();
    setState(() {
      var convertDataToJson = jsonDecode(response.body)['results'];
       for(var convertDataToJson in convertDataToJson){
         list.add(SearchMovie.fromJsonMap(convertDataToJson));
       }
    });
    return list;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SafeArea(
              child: SearchBar<SearchMovie>(
                minimumChars: 1,
                searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
                headerPadding: EdgeInsets.symmetric(horizontal: 10),
                listPadding: EdgeInsets.symmetric(horizontal: 10),
                onSearch: getSearchMovies,
                searchBarController: _searchBarController,
                placeHolder: Text("placeholder"),
                cancellationWidget: Text("Cancel"),
                emptyWidget: Text("empty"),
               // indexedScaledTileBuilder: (int index) => ScaledTile.count(1, index.isEven ? 1 : 1),
                header: Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("sort"),
                      onPressed: () {
                      },
                    ),
                    RaisedButton(
                      child: Text("Desort"),
                      onPressed: () {
                        _searchBarController.removeSort();
                      },
                    ),
                    RaisedButton(
                      child: Text("Replay"),
                      onPressed: () {
                        isReplay = !isReplay;
                        _searchBarController.replayLastSearch();
                      },
                    ),
                  ],
                ),
                onCancelled: () {
                  print("Cancelled triggered");
                },
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 2,
                onItemFound: (SearchMovie searchMovie, int index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsMovie(passData: searchMovie.id.toString())));
                    },
                    child: Container(
                      height: 300,
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/null_image.png",
                                placeholderCacheWidth: 250,
                                placeholderScale: 0.5,
                                image:searchMovie.poster_path==null ? "assets/images/null_image.png" :  "https://image.tmdb.org/t/p/original" +
                                    searchMovie.poster_path,
                                imageCacheWidth: 200,
                                height: 250,
                              )
                          ),
                          AutoSizeText(searchMovie.title,style: TextStyle(fontWeight: FontWeight.w800),),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50,left: 10),
            child: ClipOval(
              child: Material(
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Colors.grey, // inkwell color
                  child: SizedBox(width: 35, height: 35, child: Icon(Icons.arrow_back_ios, color: Colors.black,),),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text("Detail"),
          ],
        ),
      ),
    );
  }
}