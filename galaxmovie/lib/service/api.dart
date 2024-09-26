import 'dart:convert';
import 'package:galaxmovie/model/movie_model.dart';
import 'package:galaxmovie/model/search_result.dart';
import 'package:galaxmovie/service/api_constants.dart';
import 'package:http/http.dart' as http;

class Api {
  final upComingApiUrl =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  final popularApiUrl =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  final topRatedApiUrl =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";
  final nowPlayingUrl =
      "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey";
  final genresUrl =
      "https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey";

  //https://api.themoviedb.org/3/movie/popular?language=en-US&page=$page&api_key=$apiKey"

  Future<Map<int, String>> fetchGenres() async {
    final response = await http.get(Uri.parse(genresUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> genres = data['genres'];
      Map<int, String> genreMap = {};

      for (var genre in genres) {
        genreMap[genre['id']] = genre['name'];
      }

      return genreMap;
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(upComingApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      final genreMap = await fetchGenres();

      List<Movie> movies =
          data.map((movie) => Movie.fromMap(movie, genreMap)).toList();
      return movies;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<Movie>> getnowPlayingMovies() async {
    final response = await http.get(Uri.parse(nowPlayingUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      final genreMap = await fetchGenres();

      List<Movie> movies =
          data.map((movie) => Movie.fromMap(movie, genreMap)).toList();
      return movies;
    } else {
      throw Exception('Failed to load nowplaying movies');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse(popularApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      final genreMap = await fetchGenres(); // genres'ı al

      List<Movie> movies =
          data.map((movie) => Movie.fromMap(movie, genreMap)).toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(topRatedApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      final genreMap = await fetchGenres();

      List<Movie> movies =
          data.map((result) => Movie.fromMap(result, genreMap)).toList();
      return movies;
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<List<Movie>> getAllNowPlayingMovies() async {
    final genreMap = await fetchGenres();
    final List<Movie> allMovies = [];
    int page = 1;

    while (page <= 5) {
      try {
        final response = await http.get(Uri.parse(
            "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=$page&api_key=$apiKey"));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> moviesData = data['results'];

          allMovies.addAll(moviesData
              .map((movie) => Movie.fromMap(movie, genreMap))
              .toList());
          page++;
        } else {
          throw Exception('Failed to load top rated movies');
        }
      } catch (e) {
        break;
      }
    }
    return allMovies;
  }

  Future<List<Movie>> getAllTopRatedMovies() async {
    final genreMap = await fetchGenres();
    final List<Movie> allMovies = [];
    int page = 1;

    while (page <= 5) {
      try {
        final response = await http.get(Uri.parse(
            "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=$page&api_key=$apiKey"));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> moviesData = data['results'];

          allMovies.addAll(moviesData
              .map((movie) => Movie.fromMap(movie, genreMap))
              .toList());
          page++;
        } else {
          throw Exception('Failed to load top rated movies');
        }
      } catch (e) {
        break;
      }
    }
    return allMovies;
  }

  Future<List<Movie>> getAllPopularMovies() async {
    final genreMap = await fetchGenres();
    final List<Movie> allMovies = [];
    int page = 1;

    while (page <= 5) {
      try {
        final response = await http.get(Uri.parse(
            "https://api.themoviedb.org/3/movie/popular?language=en-US&page=$page&api_key=$apiKey"));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> moviesData = data['results'];

          allMovies.addAll(moviesData
              .map((movie) => Movie.fromMap(movie, genreMap))
              .toList());
          page++;
        } else {
          throw Exception('Failed to load top rated movies');
        }
      } catch (e) {
        break;
      }
    }
    return allMovies;
  }

  Future<List<Movie>> getAllUpComingMovies() async {
    final genreMap = await fetchGenres();
    final List<Movie> allMovies = [];
    int page = 1;

    while (page <= 5) {
      try {
        final response = await http.get(Uri.parse(
            "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=$page&api_key=$apiKey"));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> moviesData = data['results'];

          allMovies.addAll(moviesData
              .map((movie) => Movie.fromMap(movie, genreMap))
              .toList());
          page++;
        } else {
          throw Exception('Failed to load top rated movies');
        }
      } catch (e) {
        break;
      }
    }
    return allMovies;
  }

  static const baseUrl = 'https://api.themoviedb.org/3/';
   Future<SearchModel> searchMovies(String searchText) async {
    String endPoint = 'search/movie?query=$searchText';
    final url = '$baseUrl$endPoint&api_key=$apiKey'; 
    // ignore: avoid_print
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // ignore: avoid_print
      print('success');
      return SearchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load search movie');
  }
}

//https://api.themoviedb.org/3/search/movie?query=Jack+Reacher&api_key=a87ac813678accb2e28e07a33a49cf70
