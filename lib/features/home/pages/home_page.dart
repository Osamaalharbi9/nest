import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest/features/home/models/movie.dart';
import 'package:nest/features/home/pages/movie_details.dart';
import 'package:nest/features/home/providers/movie_provider.dart';
import 'package:nest/features/home/pages/movies_category_list.dart';
import 'package:nest/features/home/pages/search_page.dart';
import 'package:nest/features/home/widgets/movie_card.dart';
import 'package:nest/features/home/widgets/movies_row.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  late PageController _pageController;
  Timer? _pageChangeTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _pageChangeTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page!.toInt() + 1) % 5;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageChangeTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieNotifier = ref.read(movieProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                },
                child: const Icon(Icons.search)),
            centerTitle: true,
            pinned: false,
            floating: true,
            expandedHeight: 500.h,
            flexibleSpace: FlexibleSpaceBar(
              background: FutureBuilder(
                future: movieNotifier.fetchUpcomingMovies(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No data'));
                  } else {
                    return Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: snapshot.data!.take(5).length,
                          itemBuilder: (context, index) {
                            return Hero(tag: snapshot.data![index].uid!,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MovieDetails(
                                              movie: snapshot.data![index])));
                                },
                                child: MovieCard(
                                    raduis: 0,
                                    padding: 0,
                                    moviePoster:
                                        snapshot.data![index].posterPath!),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.sp),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SmoothPageIndicator(
                              effect: WormEffect(
                                activeDotColor:
                                    Theme.of(context).colorScheme.primary,
                                dotHeight: 7.h,
                                dotWidth: 7.w,
                              ),
                              controller: _pageController,
                              count: snapshot.data!.take(5).length,
                            ),
                          ),
                        )
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          FutureBuilder<Map<String, List<Movie>>>(
            future: movieNotifier.fetchAllMovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return SliverFillRemaining(
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No data')),
                );
              } else {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, top: 32.h),
                      child: MoviesRow(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoviesCategoryList(
                                fullCategoryList: snapshot.data!['popular']!,
                              ),
                            ),
                          );
                        },
                        rowTitle: 'Most Popular',
                        moviesList: snapshot.data!['popular']!,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, top: 32.h),
                      child: MoviesRow(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoviesCategoryList(
                                fullCategoryList: snapshot.data!['top_rated']!,
                              ),
                            ),
                          );
                        },
                        rowTitle: 'Top Rated',
                        moviesList: snapshot.data!['top_rated']!,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, top: 32.h),
                      child: MoviesRow(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoviesCategoryList(
                                fullCategoryList: snapshot.data!['upcoming']!,
                              ),
                            ),
                          );
                        },
                        rowTitle: 'Upcoming',
                        moviesList: snapshot.data!['upcoming']!,
                      ),
                    ),
                    SizedBox(
                      height: 100.h,
                    )
                  ]),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
