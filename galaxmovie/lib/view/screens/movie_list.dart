import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:galaxmovie/model/movie_model.dart';
import 'package:galaxmovie/view/screens/movie_detail.dart';
import 'package:galaxmovie/view_model/movie_list_viewmodel.dart';


class MovieList extends StatelessWidget {
  final String category;

  const MovieList({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: MovieListViewModel().fetchMoviesForCategory(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final movies = snapshot.data!;
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            backgroundColor:
                Colors.transparent, 
            body: _buildMovieList(context, movies),
          );
        }
      },
    );
  }

  Widget _buildMovieList(BuildContext context, List<Movie> movies) {
    final posterSize =
        MediaQuery.of(context).size.width / 3; 
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3, 
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () => _navigateToMovieDetail(context, movie),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl:
                    "https://image.tmdb.org/t/p/original/${movie.posterPath}",
                fit: BoxFit.cover,
                height: posterSize,
                width: posterSize,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToMovieDetail(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetail(movie: movie),
      ),
    );
  }
}
