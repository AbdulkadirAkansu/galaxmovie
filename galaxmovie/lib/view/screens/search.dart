import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galaxmovie/model/movie_model.dart';
import 'package:galaxmovie/model/search_result.dart';
import 'package:galaxmovie/view/screens/home.dart';
import 'package:galaxmovie/view/screens/movie_detail.dart';
import 'package:galaxmovie/view_model/search_viewmodel.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 15, 15, 15),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchField(context),
              Expanded(
                child: Consumer<SearchViewModel>(
                  builder: (context, searchViewModel, child) {
                    return searchViewModel.isSearchedMovieNull
                        ? _buildInitialMessage()
                        : _buildSearchResults(searchViewModel);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            CupertinoIcons.search,
            color: Colors.grey,
          ),
          hintText: 'Search',
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            // Handle empty search
          } else {
            Provider.of<SearchViewModel>(context, listen: false).search(value);
          }
        },
      ),
    );
  }

  Widget _buildInitialMessage() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'There is no movie searched.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
                height: 8), 
            Text(
              'Please write the movie you want to search for.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(SearchViewModel searchViewModel) {
    final searchedMovie = searchViewModel.searchedMovie;

    if (searchedMovie == null || searchedMovie.results.isEmpty) {
    return _buildInitialMessage();
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: searchViewModel.searchedMovie!.results.length,
      itemBuilder: (context, index) {
        final result = searchedMovie.results[index];
        return GestureDetector(
          onTap: () {
            _navigateToMovieDetail(context, result);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: result.backdropPath != null
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(
                              "https://image.tmdb.org/t/p/original/${result.backdropPath}",
                            ),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.darken,
                            ),
                          )
                        : null,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 10,
                        child: result.posterPath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://image.tmdb.org/t/p/original/${result.posterPath}",
                                  width: 80,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "assets/moviepic.png",
                                  width: 80,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Positioned(
                        top: 15,
                        left: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.title,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${result.releaseDate.year}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: 250,
                              child: Text(
                                "${result.overview.substring(0, min(100, result.overview.length))}...",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                softWrap: true,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _navigateToMovieDetail(BuildContext context, Result result) {
  Movie movie = resultToMovie(result);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MovieDetail(movie: movie),
    ),
  );
}