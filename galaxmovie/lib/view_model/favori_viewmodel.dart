import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galaxmovie/model/movie_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _favoritesCollection;

  List<Movie> _favoriteMovies = [];
  List<Movie> get favoriteMovies => _favoriteMovies;

  FavoritesProvider() {
    _favoritesCollection = _firestore.collection('favorites');
  }

  bool isFavorite(Movie movie) {
    return _favoriteMovies.any((element) => element.id == movie.id);
  }

  Future<List<Movie>> getFavorites(String userId) async {
    List<Movie> favorites = [];
    try {
      QuerySnapshot querySnapshot =
          await _favoritesCollection.doc(userId).collection('movies').get();
      for (var doc in querySnapshot.docs) {
        Movie movie = Movie(
          title: doc['title'],
          backDropPath: doc['backDropPath'],
          overview: doc['overview'],
          posterPath: doc['posterPath'],
          releaseDate: doc['releaseDate'],
          voteAverage: doc['voteAverage'],
          voteCount: doc['voteCount'],
          adult: doc['adult'],
          genreIds: List<int>.from(doc['genreIds'] ?? []),
          id: doc['id'],
          originalLanguage: doc['originalLanguage'],
          originalTitle: doc['originalTitle'],
          popularity: doc['popularity'],
          video: doc['video'],
          genres: List<String>.from(doc['genres'] ?? []),
        );
        if (!favorites.contains(movie)) {
          favorites.add(movie);
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print("Hata: $e");
    }
    _favoriteMovies = favorites;
    return favorites;
  }

  Future<void> addFavorite(String userId, Movie movie) async {
    try {
      if (!isFavorite(movie)) {
        await _favoritesCollection
            .doc(userId)
            .collection('movies')
            .doc(movie.id.toString())
            .set({
          'title': movie.title,
          'posterPath': movie.posterPath,
        });
        _favoriteMovies.add(movie);
        notifyListeners();
      } else {
        // ignore: avoid_print
        print('Movie is already a favorite');
      }
    } catch (e) {
      // ignore: avoid_print
      print("Hata: $e");
    }
  }

  Future<void> removeFavorite(String userId, Movie movie) async {
    try {
      await _favoritesCollection
          .doc(userId)
          .collection('movies')
          .doc(movie.id.toString())
          .delete();
      _favoriteMovies.removeWhere((m) => m.id == movie.id);
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print("Hata: $e");
    }
  }
}
