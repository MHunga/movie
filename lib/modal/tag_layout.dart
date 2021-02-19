import 'dart:convert';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/animate_title.dart';
import 'package:http/http.dart' as http;
import 'package:movie/details_movie.dart';

class TagLayout extends StatefulWidget {
  final String backdropPath;
  final String posterPath;
  final String title;
  final String id;
  const TagLayout(
      {Key key, this.backdropPath, this.posterPath, this.title, this.id})
      : super(key: key);
  @override
  TagLayoutState createState() => TagLayoutState();
}

class TagLayoutState extends State<TagLayout> {
  final String baseURL =
      "https://api.themoviedb.org/3/discover/movie?api_key=9bb89316d8693b06d7a84980b29c011f";
  ScrollController _scrollController;
  List list;
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    this.getListMovies();
  }

  Future<String> getListMovies() async {
    var response = await http.get(
        Uri.encodeFull(baseURL + "&with_keywords=${widget.id}"),
        headers: {"Accept": "application/json"});
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      list = convertDataToJson['results'];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size.width;
    double _widthContainerTitle = (_screenSize - 180);
    return list == null
        ? Scaffold(
      body: Center(child: new CircularProgressIndicator()),
    )
        : Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black,
                expandedHeight: 220,
                pinned: true,
                flexibleSpace: new FlexibleSpaceBar(
                    background: Container(
                      decoration: new BoxDecoration(
                          color: Colors.black,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.dstATop),
                              image: new NetworkImage(widget.backdropPath ==
                                  null ||
                                  widget.backdropPath.isEmpty
                                  ? 'https://freecinema.info/assets/img/film-placeholder.png'
                                  : 'https://image.tmdb.org/t/p/original' +
                                  widget.backdropPath))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 30, top: 90),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: "",
                                    placeholderCacheHeight: 200,
                                    image: widget.posterPath == null ||
                                        widget.posterPath.isEmpty
                                        ? 'https://freecinema.info/assets/img/film-placeholder.png'
                                        : 'https://image.tmdb.org/t/p/original' +
                                        widget.posterPath,
                                    height: 150,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: ListView.builder(
                    itemBuilder: itembuilder,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                  ),
                ),
              )
            ],
          ),
          AnimateTitle(
            scrollController: _scrollController,
            title: "The other ${widget.title} movies",
          )
        ],
      ),
    );
  }

  Widget itembuilder(BuildContext context, int index) {
    final _screenSize = MediaQuery.of(context).size.width;
    double _widthContainerTitle = (_screenSize - 180);
    return Container(
      padding: EdgeInsets.only(left: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Hero(
              tag: list[index]['id'],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/images/null_image.png",
                  placeholderCacheHeight: 150,
                  image: list[index]['poster_path'] == null ||
                      list[index]['poster_path'].isEmpty
                      ? 'https://freecinema.info/assets/img/film-placeholder.png'
                      : 'https://image.tmdb.org/t/p/original' +
                      list[index]['poster_path'],
                  height: 150,
                ),
              ),
            ),
            onTap: (){
              Navigator.of(context).push(new PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, _, __){
                    return new Material(

                      color: Colors.black45,
                      child: Container(
                        padding: const EdgeInsets.all(30.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Hero(tag: list[index]['id'],
                            child:  ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/null_image.png",
                                placeholderCacheHeight: 150,
                                image: list[index]['poster_path'] == null ||
                                    list[index]['poster_path'].isEmpty
                                    ? 'https://freecinema.info/assets/img/film-placeholder.png'
                                    : 'https://image.tmdb.org/t/p/original' +
                                    list[index]['poster_path'],
                                height: 150,
                              ),
                            ),),
                        ),
                      ),
                    );
                  }));
            },
          ),
          InkWell(
            onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsMovie(passData: list[index]['id'].toString())));
            },

            child: Column(
              children: <Widget>[
                Container(
                  width: _widthContainerTitle,
                  margin: EdgeInsets.only(
                    left: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        list[index]['title'],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 20),
                        //minFontSize: 18,
                        maxLines: 2,
                      ),
                      SizedBox(height: 15,),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Row(
                          children: <Widget>[
                            RatingBar(
                              initialRating: list[index]['vote_average'] / 2.0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.blue,
                              ),
                              onRatingUpdate: null,
                              itemSize: 23,
                            ),

                            Container(
                              margin: EdgeInsets.only(left: 5, top: 5),
                              child: Text(
                                  "(${list[index]['vote_count']} People Star)",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        margin: EdgeInsets.only(left: 5, top: 8),
                        child: Text(
                          "${list[index]['release_date']} Released ",
                          style: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
