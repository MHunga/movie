import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:http/http.dart' as http;
import 'package:movie/search.dart';
import 'package:movie/transition_route.dart';
import 'modal/choice.dart';
import 'details_movie.dart';

class MoviesLayout extends StatefulWidget {
  @override
  MoviesLayoutState createState() => new MoviesLayoutState();
}

class MoviesLayoutState extends State<MoviesLayout>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Choice choice;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: choices.length);
  }

  dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {
            Navigator.push(context,TransitionRouteRight(widget: SearchLayout()));
          }),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            print("DDDDDDD   ${_tabController.index}");
          },
          isScrollable: true,

          tabs: choices.map((Choice choice) {
            return Tab(
              text: choice.title,
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
          children:<Widget>[
            ChoiceCard(choice: choices[0], controller: _tabController,count: 0,),
            ChoiceCard(choice: choices[1], controller: _tabController,count: 1,),
            ChoiceCard(choice: choices[2], controller: _tabController,count: 2,),
            ChoiceCard(choice: choices[3], controller: _tabController,count: 3,),
          ] ,

          )


    );
  }
}

class ChoiceCard extends StatefulWidget {
  final Choice choice;
  final TabController controller;
  final int count;
  @override
  ChoiceCardState createState() => new ChoiceCardState();
  ChoiceCard({Key key, this.choice, this.controller, this.count}) : super(key: key);
}

class ChoiceCardState extends State<ChoiceCard> {
  List data;
  List list;
  String baseUrl = "https://api.themoviedb.org/3/movie";
  String apikey = "?api_key=9bb89316d8693b06d7a84980b29c011f";
  int page = 1;
  bool isScroll = false;

  @override
  void initState() {
    super.initState();
    this.getJsonMovies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getJsonMovies() async {
    var index =widget.controller.index;

    var response = await http.get(
        Uri.encodeFull(baseUrl +
            choices[widget.count].keyword +
            apikey),
        headers: {"Accept": "application/json"});
      setState(() {
        var convertDataToJson = jsonDecode(response.body);
        data = convertDataToJson['results'];
      });
    return "Success";
  }
  Future<String> _loadMore() async {
    await new Future.delayed(new Duration(seconds: 1));
    page = page +1;
    var index =widget.controller.index;
    var response = await http
        .get(Uri.encodeFull(baseUrl+choices[index].keyword+
        apikey+"&page=$page"), headers: {"Accept": "application/json"});
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      list = convertDataToJson['results'];
      data.addAll(list);
      isScroll = false;
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!isScroll&& scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    _loadMore();
                   setState(() {
                     print("$page");
                     isScroll = true;
                   });
                  }
                  return true;
                },
                child: GridView.builder(
                  itemCount: data == null ? 0 : data.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width~/(180),
                    childAspectRatio: 0.565,
                  ),
                  itemBuilder: (context, index) {
                    return new Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      margin: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsMovie(passData: data[index]['id'].toString())));

                        },
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: "assets/images/null_image.png",
                                      placeholderCacheWidth: 250,
                                      placeholderScale: 0.5,
                                      image:data[index]['poster_path']==null?"assets/images/null_image.png": "https://image.tmdb.org/t/p/original" +
                                          data[index]['poster_path'],
                                      imageCacheWidth: 250,
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 180,
                                          child: Center(
                                            child: AutoSizeText(
                                                data[index]['title'],
                                                style: TextStyle(fontSize: 14, color: Colors.white , fontWeight: FontWeight.bold),maxLines: 3,),
                                          ),
                                        ),

                                      ],
                                    )
                                )
                              ],
                            ),  Container(
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueGrey[900].withOpacity(0.5)
                              ),
                              child: AnimatedCircularChart(
                                size: Size(60, 60),
                                initialChartData: <CircularStackEntry>[
                                  new CircularStackEntry(
                                    <CircularSegmentEntry>[
                                      new CircularSegmentEntry(
                                        data[index]['vote_average']*10.0,
                                        data[index]['vote_average']<=2?Colors.red:(data[index]['vote_average']<7?Colors.orange[800]:Colors.blue[400]),
                                        rankKey: 'completed',
                                      ),
                                      new CircularSegmentEntry(
                                        100.0-data[index]['vote_average']*10.0,
                                        Colors.blueGrey[600],
                                        rankKey: 'remaining',
                                      ),
                                    ],
                                    rankKey: 'progress',
                                  ),
                                ],

                                chartType: CircularChartType.Radial,
                                percentageValues: true,
                                holeLabel: "${(data[index]['vote_average']*10.0).toInt()}",
                                holeRadius: 5,
                                edgeStyle: SegmentEdgeStyle.round,
                                labelStyle: new TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 10.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          Container(
            height: isScroll ? 50.0 : 0,
            color: Colors.transparent,
            child: Center(
              child: new CircularProgressIndicator(),
            ),
          ),
        ],
      ),

    );
  }
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Popular', keyword: "/popular"),
  const Choice(title: 'Top Rated', keyword: "/top_rated"),
  const Choice(title: 'Upcoming', keyword: "/upcoming"),
  const Choice(title: 'Now Playing', keyword: "/now_playing"),
];