import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListReview extends StatefulWidget {
  final String passData;

  const ListReview({Key key, this.passData}) : super(key: key);

  @override
  ListReviewState createState() => ListReviewState();
}

class ListReviewState extends State<ListReview> {
  List data;
  String baseUrl = "https://api.themoviedb.org/3/movie/";
  String apikey = "/reviews?api_key=9bb89316d8693b06d7a84980b29c011f";
  bool _isExpans = false;
  @override
  void initState() {
    super.initState();
    this.getReviewsMovies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getReviewsMovies() async {
    var response = await http.get(
        Uri.encodeFull(baseUrl + widget.passData + apikey),
        headers: {"Accept": "application/json"});
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      print("$convertDataToJson");
      data = convertDataToJson['results'];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    print(data.length.toString());
    return Column(
      children: <Widget>[
        _isExpans
            ? ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[800],
                ),
                itemBuilder: lisviewBuilder,
                itemCount: data.length,
                padding: EdgeInsets.only(bottom: 10),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              )
            : ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[800],
                ),
                itemBuilder: lisviewBuilder,
                itemCount: data.length < 4 ? data.length : 3,
                padding: EdgeInsets.only(bottom: 10),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
              data == null
            ? Container(height: 200,)
            : Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  _isExpans = !_isExpans;
                 /* stateKey.currentState
                      .refresh(_isExpans);*/
                });
              },
              child: data.length < 4
                  ? Text("")
                  : Text(
                _isExpans
                    ? "Show less"
                    : "Show more",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight:
                    FontWeight.w500),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget lisviewBuilder(BuildContext context, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  image: new NetworkImage(
                      "https://www.pngitem.com/pimgs/m/99-998739_dale-engen-person-placeholder-hd-png-download.png"))),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                data[index]['author'],
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width - 120,
                  child: AutoSizeText(
                    data[index]['content'],
                    maxLines: 8,
                    minFontSize: 13,
                    overflow: TextOverflow.ellipsis,
                  ))
            ],
          ),
        )
      ],
    );
  }

}
