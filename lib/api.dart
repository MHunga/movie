import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

  const baseUrlDiscover = "https://api.themoviedb.org/3/discover/movie?api_key=9bb89316d8693b06d7a84980b29c011f&sort_by=popularity.desc&page=1";

class APIDiscover {
  static Future<String> getList() async {
    var respone = await http.get(
      Uri.encodeFull(baseUrlDiscover)
    );
    return respone.body;
  }
}
