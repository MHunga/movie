import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'details_movie.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'filter.dart';
import 'movie_layout.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie example",
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    DiscoverLayout(),
    MoviesLayout(),
    Center(
      child: Scaffold(
        backgroundColor: Colors.blue,
      ),
    ),
    Center(
      child: Scaffold(
        backgroundColor: Colors.orange,
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(


          items: <BottomNavigationBarItem>[
           BottomNavigationBarItem(
              icon: Icon(
                  Icons.local_movies,
                ),
              title: Text('Discover'),
             backgroundColor: Colors.blueGrey[900]
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.movie_creation,
                ),
              title: Text('Movies'),
                backgroundColor: Colors.blueGrey[900]
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.live_tv,
                ),
              title: Text('TV'),
                backgroundColor: Colors.blueGrey[900]
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.person,
                ),
              title: Text('People'),
                backgroundColor: Colors.blueGrey[900]
            ),

          ],

          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white  ,
          unselectedItemColor: Colors.grey,
      ),

    );
  }
}

class DiscoverLayout extends StatefulWidget {
  @override
  DiscoverLayoutState createState() => new DiscoverLayoutState();
}

class DiscoverLayoutState extends State<DiscoverLayout> {
  final String baseURL =
      "https://api.themoviedb.org/3/discover/movie?api_key=9bb89316d8693b06d7a84980b29c011f";
  List data;
  List list;
  String pre ="";
  int page = 1;
  ScrollController _controller;
  @override
  void initState() {
    super.initState();
      setData();
   //this.getJsonDiscover();
  }
  Future<String> getFilter() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("saveFilter");
  }
  setData(){
    getFilter().then((value) {
      if(value.isNotEmpty){
        setState(() {
          pre = value;
          print("PPPPPP $pre");
        });
      }else{
        pre = "";
      }

    });
  }
  Future<String> getJsonDiscover() async {
    var response = await http
        .get(Uri.encodeFull(baseURL+pre), headers: {"Accept": "application/json"});
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
       data = convertDataToJson['results'];
    });
    return "Success";
  }
  double _crossAxisSpacing = 1, _mainAxisSpacing = 1, _aspectRatio = 0.54;
  int _crossAxisCount = 2;
  @override

  Widget build(BuildContext context) {
      getJsonDiscover();
      var size = MediaQuery.of(context).size;

      /*24 is for notification bar on Android*/
      final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
      final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: Builder(builder: (BuildContext context) {
            return IconButton(icon: Icon(Icons.filter_list), onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => FilterLayout()));
            });
          }),
          title: Text("Discover"),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[900],
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => SearchLayout()));
            }),
          ]),
      body: RefreshIndicator(
        onRefresh: _refresh,

            child: GridView.builder(
                controller: new ScrollController(keepScrollOffset: false),
                itemCount: data == null ? 0 : data.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width~/180,
                  childAspectRatio: 0.565,
                ),
                itemBuilder: (context, index) {
                  return new Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
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
                                    image:data[index]['poster_path']==null? "assets/images/null_image.png":  "https://image.tmdb.org/t/p/original" +
                                        data[index]['poster_path'],
                                    imageCacheWidth: 250,
                                  )
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 180 ,
                                        child: Center(
                                          child: AutoSizeText(
                                            data[index]['title'],
                                    style: TextStyle(fontSize: 14, color: Colors.white , fontWeight: FontWeight.bold),
                                          maxLines: 3,),
                                        ),
                                      ),

                                    ],
                          )
                              )
                            ],
                          ),
                          Container(
                            width: 40,
                            decoration: BoxDecoration(
                               shape: BoxShape.circle,
                              color: Colors.blueGrey[900].withOpacity(0.5)
                            ),
                            margin: EdgeInsets.only(right: 0),
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

    );
  }

  Future<bool> _loadMore() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    page = page+1;
    list.clear();
    load();
    return true;
  }

  Future<String> load() async{
    var response = await http
        .get(Uri.encodeFull(baseURL+pre+"&page=2"), headers: {"Accept": "application/json"});
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      list = convertDataToJson['results'];

        data = data + list;

    });
    return "Success";
  }

  Future<void> _refresh() async{
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    data.clear();
    //load(page);
  }
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_controller.position.extentAfter == 0) {
        load();
      }
    }
    return false;
  }
}



