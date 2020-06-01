
class BelongsToCollection {

  final int id;
  final String name;
  final String poster_path;
  final String backdrop_path;

	BelongsToCollection.fromJsonMap(Map<String, dynamic> map): 
		id = map["id"],
		name = map["name"],
		poster_path = map["poster_path"],
		backdrop_path = map["backdrop_path"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['name'] = name;
		data['poster_path'] = poster_path;
		data['backdrop_path'] = backdrop_path;
		return data;
	}
}
