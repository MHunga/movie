import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/modal/details_modal.dart';

class HeaderDetails extends StatefulWidget {
  final String backdropPath;
  final String posterPath;
  final int id;
  final String title;
  final String genres;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  const HeaderDetails(
      {Key key,
      this.backdropPath,
      this.posterPath,
      this.id,
      this.title,
      this.genres,
      this.voteAverage,
      this.voteCount,
      this.releaseDate})
      : super(key: key);
  @override
  HeaderDetailsState createState() => HeaderDetailsState();
}

class HeaderDetailsState extends State<HeaderDetails> {
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size.width;
    double _widthContainerTitle = (_screenSize - 180);
    return Container(
      height: 350,
      decoration: new BoxDecoration(
          color: Colors.black,
          image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.dstATop),
              image: new NetworkImage(widget.backdropPath==null||widget.backdropPath.isEmpty
                  ?'https://freecinema.info/assets/img/film-placeholder.png'
                  :'https://image.tmdb.org/t/p/original' +
                  widget.backdropPath))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, top: 90),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  child: Hero(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FadeInImage.assetNetwork(
                        placeholder: "",
                        placeholderCacheHeight: 200,
                        image:widget.posterPath==null||widget.posterPath.isEmpty
                            ?'https://freecinema.info/assets/img/film-placeholder.png'
                            : 'https://image.tmdb.org/t/p/original' +
                            widget.posterPath,
                        width: 150,
                      ),
                    ),
                    tag: widget.id,
                  ),
                  onTap: () {
                    Navigator.of(context).push(new PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, _, __) {
                          return new Material(
                            color: Colors.black45,
                            child: new Container(
                              padding: const EdgeInsets.all(30.0),
                              child: InkWell(
                                child: Hero(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: "",
                                      placeholderCacheHeight: 200,
                                      image:widget.posterPath==null||widget.posterPath.isEmpty
                                    ?'https://freecinema.info/assets/img/film-placeholder.png'
                                        : 'https://image.tmdb.org/t/p/original' +
                                      widget.posterPath,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  tag: widget.id,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        }));
                  },
                ),
                Column(
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
                            widget.title==null||widget.title.isEmpty?"":
                            widget.title,
                            style: TextStyle(
                                color: Colors.transparent,
                                fontWeight: FontWeight.w900,
                                fontSize: 30),
                            //minFontSize: 18,
                            maxLines: 2,
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 8, left: 5),
                              child: AutoSizeText(
                                widget.genres==null||widget.genres.isEmpty?"":
                                widget.genres,
                                style: TextStyle(
                                    color: Colors.grey.shade300,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15),
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                              children: <Widget>[
                                RatingBar(
                                  initialRating: widget.voteAverage / 2,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 1.0),
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
                                      "(${widget.voteCount} Peolpe Star)",
                                      style: TextStyle(
                                          color: Colors.grey.shade300,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 10)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5, top: 8),
                            child: Text(
                              "${widget.releaseDate} Released ",
                              style: TextStyle(
                                  color: Colors.grey.shade300,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15),
                            ),
                          ),
                          ButtonBar(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () {
                                  print("okok");
                                },
                                fillColor: Colors.grey[700],
                                splashColor: Colors.grey.shade100,
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "Want to Watch",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                shape: StadiumBorder(),
                              ),
                              RawMaterialButton(
                                onPressed: () {},
                                fillColor: Colors.grey,
                                splashColor: Colors.grey.shade100,
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Watched",
                                        style: TextStyle(color: Colors.white))),
                                shape: StadiumBorder(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
