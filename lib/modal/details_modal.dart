import 'file:///D:/MyFlutterProject/movie/lib/modal/belongs_to_collection.dart';

class DetailsModal {

  final bool adult;
  final String backdrop_path;
  final int budget;
  final List<Object> genres;
  final String homepage;
  final int id;
  final String imdb_id;
  final String original_language;
  final String original_title;
  final String overview;
  final double popularity;
  final String poster_path;
  final List<Object> production_companies;
  final List<Object> production_countries;
  final String release_date;
  final int revenue;
  final int runtime;
  final List<Object> spoken_languages;
  final String status;
  final String tagline;
  final String title;
  final bool video;
  final double vote_average;
  final int vote_count;

	DetailsModal.fromJsonMap(Map<String, dynamic> map):
		adult = map["adult"],
		backdrop_path = map["backdrop_path"],
	//	belongs_to_collection = BelongsToCollection.fromJsonMap(map["belongs_to_collection"]),
		budget = map["budget"],
		genres = map["genres"],
		homepage = map["homepage"],
		id = map["id"],
		imdb_id = map["imdb_id"],
		original_language = map["original_language"],
		original_title = map["original_title"],
		overview = map["overview"],
		popularity = map["popularity"],
		poster_path = map["poster_path"],
		production_companies = map["production_companies"],
		production_countries = map["production_countries"],
		release_date = map["release_date"],
		revenue = map["revenue"],
		runtime = map["runtime"],
		spoken_languages = map["spoken_languages"],
		status = map["status"],
		tagline = map["tagline"],
		title = map["title"],
		video = map["video"],
		vote_average = map["vote_average"],
		vote_count = map["vote_count"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['adult'] = adult;
		data['backdrop_path'] = backdrop_path;
	//	data['belongs_to_collection'] = belongs_to_collection == null ? null : belongs_to_collection.toJson();
		data['budget'] = budget;
		data['genres'] = genres;
		data['homepage'] = homepage;
		data['id'] = id;
		data['imdb_id'] = imdb_id;
		data['original_language'] = original_language;
		data['original_title'] = original_title;
		data['overview'] = overview;
		data['popularity'] = popularity;
		data['poster_path'] = poster_path;
		data['production_companies'] = production_companies;
		data['production_countries'] = production_countries;
		data['release_date'] = release_date;
		data['revenue'] = revenue;
		data['runtime'] = runtime;
		data['spoken_languages'] = spoken_languages;
		data['status'] = status;
		data['tagline'] = tagline;
		data['title'] = title;
		data['video'] = video;
		data['vote_average'] = vote_average;
		data['vote_count'] = vote_count;
		return data;
	}
}

class Genre {
	final int id;
	final String name;
  Genre.fromJsonMap(Map<String, dynamic> map):
				id = map["id"],
				name = map["name"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['name'] = name;
		return data;
	}
}
