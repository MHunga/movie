import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerVideo extends StatefulWidget{
 final String passData;

  const TrailerVideo({Key key, this.passData}) : super(key: key);
  @override
  TrailerVideoState createState()  => TrailerVideoState();

}

class TrailerVideoState  extends State<TrailerVideo>{
  List listVideos;
  String baseUrl = "https://api.themoviedb.org/3/movie/";
  String apikey = "?api_key=9bb89316d8693b06d7a84980b29c011f";
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  Future<String> getVideoTrailer() async {
    var response = await http.get(
        Uri.encodeFull(baseUrl + widget.passData + "/videos" + apikey),
        headers: {"Accept": "application/json"});
    print("${response.body}");
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      listVideos = convertDataToJson['results'];
      print("$convertDataToJson");
      if (listVideos != null) {
        _controller = YoutubePlayerController(
          initialVideoId: listVideos[0]['key'],
          flags: YoutubePlayerFlags(
            mute: false,
            autoPlay: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        )..addListener(listener);
        _idController = TextEditingController();
        _seekToController = TextEditingController();
        _videoMetaData = YoutubeMetaData();
        _playerState = PlayerState.unknown;
      }

      // print("$genres");
    });
    return "Success";
  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }
  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    super.deactivate();
  }
  @override
  void initState() {
    this.getVideoTrailer();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: listVideos == null ||
          listVideos.isEmpty
          ? Center(
        child: Text("There is not Trailer"),
      )
          : YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor:
        Colors.blueAccent,
        topActions: <Widget>[
          Expanded(
            child: Text(
              listVideos[0]['name'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        onReady: () {},
        onEnded: (data) {},
      ),
    );
  }
}