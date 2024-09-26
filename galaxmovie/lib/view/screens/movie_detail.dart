import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:galaxmovie/model/movie_model.dart';
import 'package:galaxmovie/view_model/favori_viewmodel.dart';

class MovieDetail extends StatelessWidget {
  const MovieDetail({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 15, 15),
      body: _buildBody(context, favoritesProvider, user),
    );
  }

  Widget _buildBody(
      BuildContext context, FavoritesProvider favoritesProvider, User? user) {
    if (user == null) {
      return const Center(child: Text('Please login to add favorites'));
    } else {
      final isFavorite = favoritesProvider.isFavorite(movie);
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildBackdrop(context),
              const SizedBox(height: 7),
              _buildButtons(context, favoritesProvider, isFavorite, user.uid),
              _buildMovieDetails(),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildBackdrop(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 320,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.srcOver,
              ),
              child: Image.network(
                "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            child: _buildTitleAndPoster(),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndPoster() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.network(
            "https://image.tmdb.org/t/p/w200/${movie.posterPath}",
            fit: BoxFit.cover,
            width: 100,
            height: 150,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildMovieInfo()),
      ],
    );
  }

  Widget _buildMovieInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.title,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        _buildRatingAndReleaseDate(),
      ],
    );
  }

  Widget _buildRatingAndReleaseDate() {
    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Colors.yellow,
          size: 14,
        ),
        Text(
          ' ${movie.voteAverage.toStringAsFixed(1)}',
          style: const TextStyle(
            color: Colors.yellow,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          ' ( ${movie.voteCount} voted )',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          ' ${movie.releaseDate.isNotEmpty ? movie.releaseDate.substring(0, 4) : ""}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context,
      FavoritesProvider favoritesProvider, bool isFavorite, String userId) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(child: _buildWatchButton(context)),
          const SizedBox(width: 16),
          Expanded(
              child: _buildAddListButton(
                  context, favoritesProvider, isFavorite, userId)),
        ],
      ),
    );
  }

  Widget _buildWatchButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Watch Button
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(255, 245, 0, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Watch',
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1.0),
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(width: 3),
          Icon(Icons.play_arrow, color: Color.fromRGBO(0, 0, 0, 1.0)),
        ],
      ),
    );
  }

  Widget _buildAddListButton(BuildContext context,
      FavoritesProvider favoritesProvider, bool isFavorite, String userId) {
    return ElevatedButton(
      onPressed: () {
        if (isFavorite) {
          favoritesProvider.removeFavorite(userId, movie);
        } else {
          favoritesProvider.addFavorite(userId, movie);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageIcon(
            AssetImage(isFavorite ? 'assets/savefull.png' : 'assets/save.png'),
            size: 20,
            color: Colors.black,
          ),
          const SizedBox(width: 5),
          Text(
            isFavorite ? 'Remove' : 'Add List',
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Details'),
          const SizedBox(height: 12),
          _buildDetailItem('Overview', movie.overview),
          const SizedBox(height: 24),
          _buildSectionTitle('Additional Information'),
          const SizedBox(height: 12),
          _buildDetailItem('Original Language', movie.originalLanguage),
          const SizedBox(height: 5),
          _buildDetailItem('Original Title', movie.originalTitle),
          const SizedBox(height: 5),
          _buildDetailItem('Popularity', movie.popularity.toString()),
          const SizedBox(height: 5),
          _buildDetailItem('Genres', movie.genres.join(", ")),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget _buildDetailItem(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontStyle: FontStyle.normal,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
