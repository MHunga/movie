import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

import 'details_movie.dart';

class DetailsActor extends StatefulWidget{
    final String profilePath;
    final String name;
  const DetailsActor({Key key, this.profilePath, this.name}) : super(key: key);
  DetailsActorState createState() => DetailsActorState();
}

class DetailsActorState extends State<DetailsActor> {
  List dataInfo;
  List listAsKnownFor;
  List knownFor;
  String asKnownFor;
  var dataDetails;
  String baseUrl = "https://api.themoviedb.org/3/";
  String apikey = "?api_key=9bb89316d8693b06d7a84980b29c011f";

  @override
  void initState() {
    super.initState();
    this.getInfo();


  }
  Future<String> getInfo() async{
    var response = await http.get(
        Uri.encodeFull(baseUrl +"search/person" + apikey+"&query=${widget.name}"),
        headers: {"Accept": "application/json"});
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      dataInfo = convertDataToJson['results'];
      knownFor = dataInfo[0]['known_for'];
    });
    return "Success";
  }
  Future<String> getDetailsInfo() async{
    var response = await http.get(
        Uri.encodeFull(baseUrl +"person" +"/${dataInfo[0]['id']}" +apikey),
        headers: {"Accept": "application/json"});
    setState(() {
      dataDetails = jsonDecode(response.body);

      listAsKnownFor = dataDetails['also_known_as'];
      asKnownFor = "- "+ listAsKnownFor[0];
      for(int i=1 ; i < listAsKnownFor.length; i++){
        asKnownFor = asKnownFor +"\n- "+ listAsKnownFor[i];
      }
    });

    return "Success";
  }
  @override
  Widget build(BuildContext context) {
    if(dataInfo!=null){
      this.getDetailsInfo();
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.black,
                margin: EdgeInsets.only(top: 0),
                child:  Image.network(widget.profilePath, height: 400, width: MediaQuery.of(context).size.width,)
            ),


           dataInfo==null||dataDetails==null?
           Container(
             width: MediaQuery.of(context).size.width,
             height: MediaQuery.of(context).size.height-300,
             child: Center(child: CircularProgressIndicator()),
           ) : Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 380),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                        child: Center(child: Text(widget.name , style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700),)),),
                    Row(
                      children: <Widget>[
                        Container(
                         // color: Colors.blue,
                          height: 50,
                          width: MediaQuery.of(context).size.width/3,
                          child: Column(
                            children: <Widget>[
                              Text("Department", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                              SizedBox(height: 10,),
                              Text(dataInfo[0]['known_for_department'])
                            ],
                          ),
                        ),
                        Container(
                         // color: Colors.orange,
                          height: 50,
                          width: MediaQuery.of(context).size.width/3,
                          child: Column(
                            children: <Widget>[
                              Text("Birthday", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                              SizedBox(height: 10,),
                              Text(dataDetails['birthday'])
                            ],
                          ),
                        ),
                        Container(
                        //  color: Colors.green,
                          height: 50,
                          width: MediaQuery.of(context).size.width/3,
                          child: Column(
                            children: <Widget>[
                              Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                              SizedBox(height: 10,),
                              Text(dataInfo[0]['gender']==2?"Male":"Female")
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text("Biography" , style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20,left: 30, right: 30),
                      child: Text(dataDetails['biography'] , style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text("Also known as" , style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20,left: 30, right: 30),
                      child: Text(asKnownFor , style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text("Known for" , style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                    ),
                   knownFor==null?Container()
                       : ListView.builder(
                      itemCount: knownFor.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: itemKnowFor,
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget itemKnowFor(BuildContext context, int index) {
    final _screenSize = MediaQuery.of(context).size.width;
    double _widthContainerTitle = (_screenSize - 180);
    return Container(
      padding: EdgeInsets.only(left: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Hero(
              tag: knownFor[index]['id'],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/images/null_image.png",
                  placeholderCacheHeight: 150,
                  image: knownFor[index]['poster_path'] == null ||
                      knownFor[index]['poster_path'].isEmpty
                      ? 'https://freecinema.info/assets/img/film-placeholder.png'
                      : 'https://image.tmdb.org/t/p/original' +
                      knownFor[index]['poster_path'],
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
                          child: Hero(tag: knownFor[index]['id'],
                            child:  ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/null_image.png",
                                placeholderCacheHeight: 150,
                                image: knownFor[index]['poster_path'] == null ||
                                    knownFor[index]['poster_path'].isEmpty
                                    ? 'https://freecinema.info/assets/img/film-placeholder.png'
                                    : 'https://image.tmdb.org/t/p/original' +
                                    knownFor[index]['poster_path'],
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
            onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsMovie(passData: knownFor[index]['id'].toString())));
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
                        knownFor[index]['title'],
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
                              initialRating: knownFor[index]['vote_average'] / 2.0,
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
                                  "(${knownFor[index]['vote_count']} People Star)",
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
                          "${knownFor[index]['release_date']} Released ",
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