import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:movie/animate_title.dart';
import 'package:movie/header_details.dart';
import 'package:movie/modal/tag_layout.dart';
import 'file:///D:/MyFlutterProject/movie/lib/modal/details_modal.dart';
import 'package:movie/trailer_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'list_actors.dart';
import 'list_review.dart';

// ignore: must_be_immutable
class DetailsMovie extends StatefulWidget {
  final String passData;
  @override
  DetailsMovieState createState() => new DetailsMovieState();
  DetailsMovie({Key key, @required this.passData}) : super(key: key);
}

class DetailsMovieState extends State<DetailsMovie> {
  DetailsModal detailsModal;
  List listGenre;
  List listVideos;
  List listTag;
  String baseUrl = "https://api.themoviedb.org/3/movie/";
  String apikey = "?api_key=9bb89316d8693b06d7a84980b29c011f";
  String genres;
  ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();

    super.initState();
    this.getDetailsMovies();
    this.getTagMovies();
  }

  Future<String> getDetailsMovies() async {
    var response = await http.get(
        Uri.encodeFull(baseUrl + widget.passData + apikey),
        headers: {"Accept": "application/json"});
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      detailsModal = DetailsModal.fromJsonMap(convertDataToJson);

      listGenre = convertDataToJson['genres'];
      genres = listGenre[0]['name'];
      for (int i = 1; i < listGenre.length; i++) {
        genres = genres + "/" + listGenre[i]['name'];
      }
      // print("$genres");
    });
    return "Success";
  }

  Future<String> getTagMovies() async {
    var response = await http.get(
        Uri.encodeFull(baseUrl + widget.passData + "/keywords" + apikey),
        headers: {"Accept": "application/json"});
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      listTag = convertDataToJson['keywords'];
    });
    return "Success";
  }


  @override
  Widget build(BuildContext context) {
    print("${widget.passData}");



    return detailsModal == null
        ? Scaffold(body: Center(child: const CircularProgressIndicator()))
        : Scaffold(
            backgroundColor: Colors.transparent,
            body:

           Stack(
             children: <Widget>[
               new CustomScrollView(
                 scrollDirection: Axis.vertical,
                 controller: _scrollController,
                 slivers: <Widget>[
                   new SliverAppBar(backgroundColor: Colors.black,
                     expandedHeight: 300,
                     pinned: true,

                     flexibleSpace: new FlexibleSpaceBar(
                       background:  HeaderDetails(title: detailsModal.title, backdropPath: detailsModal.backdrop_path,
                       genres: genres, id: detailsModal.id,posterPath: detailsModal.poster_path, releaseDate: detailsModal.release_date,
                       voteAverage: detailsModal.vote_average, voteCount: detailsModal.vote_count,),
                     ),
                   ),
                   new SliverToBoxAdapter(
                     child: new Container(
                       margin: EdgeInsets.only(top: 0),
                       decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.only(
                               topRight: Radius.circular(10),
                               topLeft: Radius.circular(10))),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Container(
                               margin: EdgeInsets.only(top: 20, left: 20),
                               child: Text(
                                 "Actors",
                                 style: TextStyle(
                                     fontSize: 18, fontWeight: FontWeight.w500),
                               )),
                           Container(
                               height: 180,
                               width: MediaQuery.of(context).size.width,
                               margin: EdgeInsets.all(10),
                               child: ListActor(
                                 passData: widget.passData,
                               )),
                           Container(
                             width: MediaQuery.of(context).size.width,
                             margin: EdgeInsets.only(top: 20, left: 20),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Text("Tag",
                                     style: TextStyle(
                                         fontSize: 18,
                                         fontWeight: FontWeight.w500)),
                                 listTag == null || listTag.isEmpty
                                     ? Container()
                                     : ButtonBar(
                                   mainAxisSize: MainAxisSize.min,
                                   children: <Widget>[
                                     RawMaterialButton(
                                       onPressed: () { Navigator.push(context,
                                           MaterialPageRoute(builder: (context) =>
                                               TagLayout(posterPath: detailsModal.poster_path,
                                         backdropPath: detailsModal.backdrop_path ,
                                         title: listTag[0]['name'], id: listTag[0]['id'].toString(),)));},
                                       fillColor: Colors.blue,
                                       splashColor: Colors.grey.shade100,
                                       child: Container(
                                           padding: EdgeInsets.all(5),
                                           child: Text(
                                             listTag[0]['name'],
                                             style: TextStyle(
                                                 color: Colors.white),
                                           )),
                                       shape: StadiumBorder(),
                                     ),
                                     listTag.length < 2
                                         ? Text("")
                                         : RawMaterialButton(
                                       onPressed: () {
                                         Navigator.push(context,
                                             MaterialPageRoute(builder: (context) =>
                                                 TagLayout(posterPath: detailsModal.poster_path,
                                                   backdropPath: detailsModal.backdrop_path ,
                                                   title: listTag[1]['name'], id: listTag[1]['id'].toString(),)));
                                       },
                                       fillColor: Colors.blue,
                                       splashColor:
                                       Colors.grey.shade100,
                                       child: Container(
                                           padding: EdgeInsets.all(5),
                                           child: Text(
                                               listTag[1]['name'],
                                               style: TextStyle(
                                                   color:
                                                   Colors.white))),
                                       shape: StadiumBorder(),
                                     ),
                                     listTag.length < 3
                                         ? Text("")
                                         : RawMaterialButton(
                                       onPressed: () {
                                         Navigator.push(context,
                                             MaterialPageRoute(builder: (context) =>
                                                 TagLayout(posterPath: detailsModal.poster_path,
                                                   backdropPath: detailsModal.backdrop_path ,
                                                   title: listTag[2]['name'], id: listTag[2]['id'].toString(),)));
                                       },
                                       fillColor: Colors.blue,
                                       splashColor:
                                       Colors.grey.shade100,
                                       child: Container(
                                           padding: EdgeInsets.all(5),
                                           child: Text(
                                               listTag[2]['name'],
                                               style: TextStyle(
                                                   color:
                                                   Colors.white))),
                                       shape: StadiumBorder(),
                                     )
                                   ],
                                 ),
                               ],
                             ),
                           ),
                           Container(
                             width: MediaQuery.of(context).size.width,
                             margin: EdgeInsets.only(top: 20, left: 20),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Text("Introduction",
                                     style: TextStyle(
                                         fontSize: 18,
                                         fontWeight: FontWeight.w500)),
                                 Container(
                                     margin: EdgeInsets.only(top: 10, left: 10),
                                     child: Text(detailsModal.overview))
                               ],
                             ),
                           ),
                           Container(
                             width: MediaQuery.of(context).size.width,
                             margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Text("Trailer",
                                     style: TextStyle(
                                         fontSize: 18,
                                         fontWeight: FontWeight.w500)),
                                 Container(
                                   margin: EdgeInsets.only(top: 20),
                                   child: TrailerVideo(passData: widget.passData,)
                                 ),
                               ],
                             ),
                           ),
                           Container(
                             width: MediaQuery.of(context).size.width,
                             margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Text("Review",
                                     style: TextStyle(
                                         fontSize: 18,
                                         fontWeight: FontWeight.w500)),
                                 Container(
                                     margin: EdgeInsets.only(top: 10),
                                     child: ListReview(
                                       passData: widget.passData,
                                     )),

                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                   )
                 ],
               ),

               AnimateTitle(scrollController: _scrollController, title: detailsModal.title,)
             ],
           )
    );
  }


}


