import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nest/core/services.dart';
import 'package:nest/features/auth/providers/auth_provider.dart';
import 'package:nest/features/home/providers/favourite_movies.dart';
import 'package:nest/features/home/pages/movies_category_list.dart';
import 'package:nest/features/profile/providers/ai.dart';
import 'package:nest/features/profile/providers/profile_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  File? _pickedImageFile;

  void _pickImage() async {
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      builder: (context) => SizedBox(
        height: 200.h,
        width: double.infinity,
        child: Column(
          children: [
            TextButton(onPressed: () async{
              final pickedImage=await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 50,maxWidth: 150);
              if(pickedImage==null)return;
              setState(() {
                _pickedImageFile=File(pickedImage.path);
              });
            }, child: const Text('Camera')),
            TextButton(onPressed: ()async {
              final pickedImage=await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 50,maxWidth: 150);
              if(pickedImage==null)return;
              setState(() {
                _pickedImageFile=File(pickedImage.path);
              });
            }, child: const Text('Gallery'))
          ],
        ),
      ),
    );
    // final pickedImage = await ImagePicker().pickImage(
    //   source: isCamera == true ? ImageSource.camera : ImageSource.gallery,
    //   imageQuality: 50,
    //   maxWidth: 150,
    // );
    // if (pickedImage == null) return;

    // setState(() {
    //   _pickedImageFile = File(pickedImage.path);
    // });
  }

  void _pickBanner() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    final _authNotifier = ref.watch(authNotifier.notifier);
    final movieNotifier = ref.read(profileProvider.notifier);
    final favouriteMoviesNotifier = ref.read(favouriteMoviesProvider.notifier);
    final favouriteProvider = ref.watch(favouriteMoviesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            expandedHeight: 110.0.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: GestureDetector(
                          onTap: () {
                            _pickImage();
                          },
                          child: CircleAvatar(
                            radius: 40.r,
                            backgroundImage: _pickedImageFile != null
                                ? FileImage(_pickedImageFile!)
                                : null,
                            child: _pickedImageFile == null
                                ? IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: _pickImage,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: Column(
                          children: [
                            const Text(
                              'Username',
                            ),
                            GestureDetector(
                              onTap: () async {
                                await _authNotifier.logout();
                              },
                              child: Icon(
                                Icons.exit_to_app,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 32),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Stats',
                      style: TextStyle(
                          fontSize: 24.sp, fontWeight: FontWeight.w800),
                    ),
                  ),
                  FutureBuilder(
                    future: movieNotifier.viewStats(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Display a loading indicator while waiting
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Text(snapshot.data.toString());
                      } else {
                        return Text('No movies found');
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'List',
                          style: TextStyle(
                              fontSize: 24.sp, fontWeight: FontWeight.w800),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Container(
                          width: double.infinity,
                          height: 140.h,
                          child: FutureBuilder(
                            future: movieNotifier.fetchUserList(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No movies found'));
                              } else {
                                final movies = snapshot.data!;
                                final newList = movies.take(4);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MoviesCategoryList(
                                                  fullCategoryList:
                                                      snapshot.data!,
                                                )));
                                  },
                                  child: Row(
                                    children: [
                                      for (final movie in newList)
                                        Container(
                                          width: 80,
                                          height: 120,
                                          child: Image.network(
                                              httpPoster + movie.posterPath!),
                                        )
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      ElevatedButton(onPressed: () {}, child: Text('ai')),
                      FutureBuilder(
                        future: movieNotifier.fetchUserList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(child: Text('No movies found'));
                          } else {
                            final userMovies = snapshot.data!;
                            List<String> userListTitles = [];
                            for (final titles in userMovies)
                              userListTitles.add(titles.title!);
                            return FutureBuilder(
                              future:
                                  getMovieNightRecommendation(userListTitles),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                      child: Text('No movies found'));
                                } else {
                                  return Text(snapshot.data!);
                                }
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}