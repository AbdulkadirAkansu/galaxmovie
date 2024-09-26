class Genres {
  List<Genres>? genres;

  Genres({this.genres});

  Genres.fromJson(Map<String, dynamic> json) {
    if (json['genres'] != null) {
      genres = [];
      json['genres'].forEach((v) {
        genres!.add(Genres.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (genres != null) {
      data['genres'] = genres!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
