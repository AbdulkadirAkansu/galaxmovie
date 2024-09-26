import 'package:flutter/material.dart';
import 'package:galaxmovie/model/search_result.dart';
import 'package:galaxmovie/service/api.dart'; 

class SearchViewModel extends ChangeNotifier {
  final Api _api = Api();

  SearchModel? _searchedMovie;
  SearchModel? get searchedMovie => _searchedMovie;

  Future<void> search(String query) async {
    try {
      _searchedMovie = await _api.searchMovies(query);
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error searching movies: $e');
      _searchedMovie = null;
    }
  }

  bool get isSearchedMovieNull => _searchedMovie == null;
}
