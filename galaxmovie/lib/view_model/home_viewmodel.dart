import 'package:flutter/material.dart';
import 'package:galaxmovie/model/movie_model.dart';
import 'package:galaxmovie/service/api.dart';

class HomeViewModel extends ChangeNotifier {
  late Future<List<Movie>> upcomingMovies;
  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> nowPlayingMovies;
  late Future<Map<int, String>> genre;
  late Future<List<Movie>> allnowPlayingMovies;
  late Future<List<Movie>> allTopRatedMovies;
  late Future<List<Movie>> allPopularMovies;

  ValueNotifier<String> currentTitle = ValueNotifier<String>("");

  HomeViewModel() {
    upcomingMovies = Api().getUpcomingMovies();
    popularMovies = Api().getPopularMovies();
    topRatedMovies = Api().getTopRatedMovies();
    nowPlayingMovies = Api().getnowPlayingMovies();
    genre = Api().fetchGenres();
    allnowPlayingMovies = Api().getAllNowPlayingMovies();
    allTopRatedMovies = Api().getAllTopRatedMovies();
    allPopularMovies = Api().getAllPopularMovies();
  }
}
