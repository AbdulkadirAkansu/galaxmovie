

class Movie {
  final String title;
  final String backDropPath;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final bool adult;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final double popularity;
  final bool video;
  List<String> genres; 

  Movie({
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.adult,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
    required this.video,
    required this.genres, 
  });

  factory Movie.fromMap(Map<String, dynamic> map, Map<int, String> genreMap) {
    List<String> genreNames = [];
    if (map['genre_ids'] != null) {
      map['genre_ids'].forEach((id) {
        if (genreMap.containsKey(id)) {
          genreNames.add(genreMap[id]!);
        }
      });
    }

    
    return Movie(
      title: map['title'] ?? '',
      backDropPath: map['backdrop_path'] ?? '',
      overview: map['overview'] ?? '',
      posterPath: map['poster_path'] ?? '',
      releaseDate: map['release_date'] ?? '',
      voteAverage: map['vote_average']?.toDouble() ?? 0.0,
      voteCount: map['vote_count'] ?? 0,
      adult: map['adult'] ?? false,
      genreIds: map['genre_ids'] != null ? List<int>.from(map['genre_ids']) : [],
      id: map['id'] ?? 0,
      originalLanguage: map['original_language'] ?? '',
      originalTitle: map['original_title'] ?? '',
      popularity: map['popularity']?.toDouble() ?? 0.0,
      video: map['video'] ?? false,
      genres: genreNames, 
    );
  }

 

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'backDropPath': backDropPath,
      'overview': overview,
      'posterPath': posterPath,
      'releaseDate': releaseDate,
      'voteAverage': voteAverage,
      'voteCount': voteCount,
      'adult': adult,
      'genreIds': genreIds,
      'id': id,
      'originalLanguage': originalLanguage,
      'originalTitle': originalTitle,
      'popularity': popularity,
      'video': video,
    };
  }
}
