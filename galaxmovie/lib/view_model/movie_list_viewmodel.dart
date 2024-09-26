import 'package:galaxmovie/model/movie_model.dart';
import 'package:galaxmovie/service/api.dart';

class MovieListViewModel {
  Future<List<Movie>> fetchMoviesForCategory(String category) async {
    switch (category) {
      case 'UpComing':
        return Api().getAllUpComingMovies();
      case 'Popular':
        return Api().getAllPopularMovies();
      case 'Top Rated':
        return Api().getAllTopRatedMovies();
      case 'Now Playing':
        return Api().getAllNowPlayingMovies();
      default:
        return [];
    }
  }
}
