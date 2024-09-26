import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:galaxmovie/model/movie_model.dart';
import 'package:galaxmovie/view/screens/movie_detail.dart';
import 'package:galaxmovie/view/screens/movie_list.dart';
import 'package:galaxmovie/view/screens/search.dart';
import 'package:galaxmovie/view/widgets/profilemodal.dart';
import 'package:galaxmovie/view_model/home_viewmodel.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          // ignore: deprecated_member_use
          return WillPopScope(
            // Geri butonuna basıldığında hiçbir şey yapma
            onWillPop: () async => false,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: const Color.fromARGB(255, 15, 15, 15),
              appBar: _buildAppBar(context),
              body: _buildBody(context, viewModel),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0,
      leading: null,
      title: Row(
        children: [
          const SizedBox(width: 16),
          Image.asset(
            'assets/4.png',
            color: Colors.white,
            width: 38,
            height: 38,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return const ProfilePage();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, HomeViewModel viewModel) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kToolbarHeight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'UpComing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _navigateToAllMovies(context, "UpComing");
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildCarousel(context, viewModel),
          _buildMovieList(
              context, 'Popular', viewModel.popularMovies, viewModel),
          _buildMovieList(
              context, 'Top Rated', viewModel.topRatedMovies, viewModel),
          _buildMovieList(
              context, 'Now Playing', viewModel.nowPlayingMovies, viewModel),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, HomeViewModel viewModel) {
    return FutureBuilder(
      future: viewModel.upcomingMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading upcoming movies'),
          );
        }
        final List<Movie> movies = snapshot.data as List<Movie>;
        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: movies.length,
              itemBuilder: (context, index, movieIndex) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToMovieDetail(context, movie);
                  },
                  child: _buildCarouselItem(context, movie),
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 11,
                autoPlayInterval: const Duration(seconds: 5),
                viewportFraction: 0.5,
                onPageChanged: (index, reason) {
                  viewModel.currentTitle.value = movies[index].title;
                },
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<String>(
              valueListenable: viewModel.currentTitle,
              builder: (context, value, child) {
                final selectedMovie = movies.firstWhere(
                  (movie) => movie.title == value,
                  orElse: () => Movie(
                    title: '',
                    backDropPath: '',
                    overview: '',
                    posterPath: '',
                    releaseDate: '',
                    voteAverage: 0,
                    voteCount: 0,
                    adult: false,
                    genreIds: [],
                    id: 0,
                    originalLanguage: '',
                    originalTitle: '',
                    popularity: 0.0,
                    video: false,
                    genres: [],
                  ),
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 3),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            ' ${selectedMovie.voteAverage.toStringAsFixed(1)}',
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            ' ${selectedMovie.genres.join(", ")}',
                            //'• ${selectedMovie.releaseDate.isNotEmpty ? selectedMovie.releaseDate.substring(0, 4) : ""}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(width: 40),
                        _buildActionButton(context, 'WATCH NOW', selectedMovie),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCarouselItem(BuildContext context, Movie movie) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: "https://image.tmdb.org/t/p/original/${movie.posterPath}",
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }

  Widget _buildMovieList(BuildContext context, String title,
      Future<List<Movie>> movieList, HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: TextButton(
                  onPressed: () {
                    _navigateToAllMovies(context, title);
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 220,
            child: FutureBuilder(
              future: movieList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading movies'),
                  );
                }
                final List<Movie> movies = snapshot.data as List<Movie>;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return GestureDetector(
                      onTap: () {
                        _navigateToMovieDetail(context, movie);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            margin: const EdgeInsets.symmetric(horizontal: 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://image.tmdb.org/t/p/original/${movie.posterPath}",
                                height: 195,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            child: _buildMovieTitle(movie.title),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieTitle(String title) {
    const int maxLength = 20;
    return Text(
      title.length <= maxLength ? title : '${title.substring(0, maxLength)}...',
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 12,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, title, Movie movie) {
    return Container(
      width: 250,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF500), Color(0xFFFFE600)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: TextButton(
        onPressed: () {
          _navigateToMovieDetail(context, movie);
        },
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ),
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

  void _navigateToAllMovies(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieList(category: category),
      ),
    );
  }
}
