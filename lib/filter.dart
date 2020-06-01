import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class FilterLayout extends StatefulWidget {
  @override
  FilterLayoutState createState() => FilterLayoutState();
}

class FilterLayoutState extends State<FilterLayout> {
  String keyYear="keyYear";
  String keySort="keySort";
  String keyGenre="keyGenre";
  String year = "None";
  String sort = "None";
  String genre = "None";
  String valueYear="";
  String valueSort="";
  String valueGenre="";
  String data="";
  @override
  void initState() {
    super.initState();
    setDataYear(keyYear);
    setDataSort(keySort);
    setDataGenre(keyGenre);
  }

    Future<bool> saveFilter(String valueYear,String valueSort,String valueGenre) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString("saveFilter", valueYear+valueSort+valueGenre);
} Future<bool> save(String value, String key) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(key, value);
}

  Future<String> getFilter(String key) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }
  setDataYear(String key){
    getFilter(key).then((value) {
      if(value.isNotEmpty){
        setState(() {
          year = value;
        });
      }else{
        year = "None";
      }

    });
  }
  setDataSort(String key){
    getFilter(key).then((value) {
      if(value.isNotEmpty){
        setState(() {
          sort = value;
        });
      }
      else{
        sort = "None";
      }

    });
  }setDataGenre(String key){
    getFilter(key).then((value) {
      if(value.isNotEmpty){
        setState(() {
          genre = value;
        });
      }
      else{
        genre = "None";
      }

    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
            Navigator.of(context).pop();
          });
        }),
        title: Text("Filter"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: (){
                  showDialog(context: context,
                      builder: (BuildContext  context){
                        return AlertDialog(
                            backgroundColor: Colors.blueGrey[300],
                            elevation: 10,

                            title: new Text('Year'),
                            content: Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.height * 0.3,
                                child: ListView.builder(itemBuilder: itembuiderYear,itemCount: years.length,))
                        );
                      });
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Year", style: TextStyle(fontSize: 18, color: Colors.white),),
                      Text(year, style: TextStyle(fontSize: 18, color: Colors.white))
                    ],
                  ),
                ),
              ),
              Container(color: Colors.grey,height: 2, margin: EdgeInsets.only(bottom: 15,top: 15),),
              InkWell(
                onTap: (){
                  showDialog(context: context,
                      builder: (BuildContext  context){
                        return AlertDialog(
                            backgroundColor: Colors.blueGrey[300],
                            elevation: 10,

                            title: new Text('Sort By'),
                            content: Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.height * 0.3,
                                child: ListView.builder(itemBuilder: itembuiderSort,itemCount: sorts.length,))
                        );
                      });
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Sort By", style: TextStyle(fontSize: 18, color: Colors.white),),
                      Text(sort, style: TextStyle(fontSize: 18, color: Colors.white))
                    ],
                  ),
                ),
              ),
              Container(color: Colors.grey,height: 2,margin: EdgeInsets.only(bottom: 15,top: 15),),
              InkWell(
                onTap: (){
                  showDialog(context: context,
                      builder: (BuildContext  context){
                        return AlertDialog(
                            backgroundColor: Colors.blueGrey[300],
                            elevation: 10,

                            title: new Text('Genre'),
                            content: Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.height * 0.3,
                                child: ListView.builder(itemBuilder: itembuiderGenre,itemCount: genres.length,))
                        );
                      });
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Genre", style: TextStyle(fontSize: 18, color: Colors.white),),
                      Text(genre, style: TextStyle(fontSize: 18, color: Colors.white))
                    ],
                  ),
                ),
              ),
              Container(color: Colors.grey,height: 2,margin: EdgeInsets.only(bottom: 200,top: 15),),
              RaisedButton(onPressed: (){

                    saveFilter(valueYear, valueSort, valueGenre);
                    save(year, keyYear);
                    save(sort, keySort);
                    save(genre, keyGenre);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => MyStatefulWidget()));
              },
                color: Colors.redAccent,
                elevation: 5.0,
                padding: EdgeInsets.only(top: 15, bottom: 15, left: 100, right: 100),
                child: Text("Apply Filter", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 18),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itembuiderYear(BuildContext context, int index) {
    return Container(
        height: 50,
        child: InkWell(
            onTap: (){
              setState(() {
                year = years[index].year;
                valueYear = "&year=$year";

              });

              Navigator.of(context).pop();},
            child: Center(
                child: Text(years[index].year))));
  }


  Widget itembuiderSort(BuildContext context, int index) {
    return Container(
        height: 50,
        child: InkWell(
            onTap: (){
              setState(() {
                valueSort = sorts[index].value;
                sort = sorts[index].name;

              });

              Navigator.of(context).pop();},
            child: Center(
                child: Text(sorts[index].name))));

  }

  Widget itembuiderGenre(BuildContext context, int index) {
    return Container(
        height: 50,
        child: InkWell(
            onTap: (){
              setState(() {
                genre = genres[index].name;
                valueGenre= "&with_genres=${genres[index].id.toString()}";

              });

              Navigator.of(context).pop();},
            child: Center(
                child: Text(genres[index].name))));
  }
}

class Year {
  final String year;
  final String value;
  const Year({this.year,this.value});
}
const List<Year> years = const <Year>[
  const Year(year: "2010", value: "a"),
  const Year(year: "2011", value: "a"),
  const Year(year: "2012", value: "a"),
  const Year(year: "2013", value: "a"),
  const Year(year: "2014", value: "a"),
  const Year(year: "2015", value: "a"),
  const Year(year: "2016", value: ""),
  const Year(year: "2017", value: "a"),
  const Year(year: "2018", value: "a"),
  const Year(year: "2019", value: "a"),
  const Year(year: "2020", value: "a"),
];
class SortBy{
  final String name;
  final String value;
 const SortBy({this.name, this.value});
}
const List<SortBy> sorts = const <SortBy>[
  const SortBy(name: "Popularity Ascending", value: "&sort_by=popularity.asc"),
  const SortBy(name: "Popularity Descending", value: "&sort_by=popularity.desc"),
  const SortBy(name: "Original Title Ascending", value: "&sort_by=original_title.asc"),
  const SortBy(name: "Original Title Descending", value: "&sort_by=original_title.desc"),
];

class Genre{
  final int id;
  final String name;
  final String value;

 const Genre({this.id, this.name, this.value});
}
const List<Genre> genres = const <Genre>[
  const Genre(id: 28, name: "Action", value: ""),
  const Genre(id: 12, name: "Adventure", value: ""),
  const Genre(id: 16, name: "Animation", value: ""),
  const Genre(id: 35, name: "Comedy", value: ""),
  const Genre(id: 80, name: "Crime", value: ""),
  const Genre(id: 99, name: "Documentary", value: ""),
  const Genre(id: 18, name: "Drama", value: ""),
  const Genre(id: 10751, name: "Family", value: ""),
  const Genre(id: 14, name: "Fantasy", value: ""),
  const Genre(id: 36, name: "History", value: ""),
  const Genre(id: 27, name: "Horror", value: ""),
  const Genre(id: 10402, name: "Music", value: ""),
  const Genre(id: 9648, name: "Mystery", value: ""),
  const Genre(id: 10749, name: "Romance", value: ""),
  const Genre(id: 878, name: "Science Fiction", value: ""),
  const Genre(id: 10770, name: "TV Movie", value: ""),
  const Genre(id: 53, name: "Thriller", value: ""),
  const Genre(id: 10752, name: "War", value: ""),
  const Genre(id: 37, name: "Western", value: ""),
];