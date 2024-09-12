import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:nest/core/common/widgets/custom_snack_bar.dart';
import 'package:nest/core/services.dart';
import 'package:nest/features/auth/providers/auth_provider.dart';
import 'package:nest/features/home/providers/favourite_movies.dart';
import 'package:nest/features/home/pages/movies_category_list.dart';
import 'package:nest/features/profile/providers/ai.dart';
import 'package:nest/features/profile/providers/profile_provider.dart';
import 'package:nest/features/profile/widgets/sheet_search.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  File? _pickedImageFile;
  bool _isDisabled = false;

  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  // Method to upload the image to Firebase Storage
  Future<String?> _uploadImage(File image) async {
    try {
      final userId = ref.read(authNotifier.notifier).auth.currentUser!.uid;
      final storageRef = _storage.ref().child('profile_images/$userId.jpg');
      await storageRef.putFile(image);
      final imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Method to pick the image and upload to Firebase Storage
  
  @override
  Widget build(BuildContext context) {

    final _authNotifier = ref.watch(authNotifier.notifier);
    final movieNotifier = ref.read(profileProvider.notifier);
    final favouriteMoviesNotifier = ref.read(favouriteMoviesProvider.notifier);
    Future<void> _pickAndUploadImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
        source: source, imageQuality: 50, maxWidth: 150);

    if (pickedImage == null) return;

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    if (_pickedImageFile != null) {
      final imageUrl = await _uploadImage(_pickedImageFile!);
      if (imageUrl != null) {
        // Update Firestore with the image URL
        await _firestore
            .collection('users')
            .doc(_authNotifier.auth.currentUser!.uid)
            .update({'urlImage': imageUrl});
        
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            Text('Profile image updated successfully'),
            Theme.of(context).colorScheme.secondary,
            context,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            Text('Failed to upload image'),
            Theme.of(context).colorScheme.error,
            context,
          ),
        );
      }
    }
  }


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
                          onTap: () => _pickAndUploadImage(ImageSource.gallery),
                          child: CircleAvatar(
                            radius: 40.r,
                            backgroundImage: _pickedImageFile != null
                                ? FileImage(_pickedImageFile!)
                                : null,
                            child: _pickedImageFile == null
                                ? IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: () => _pickAndUploadImage(ImageSource.camera),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: Column(
                          children: [
                            const Text('Username'),
                            GestureDetector(
                              onTap: () async {
                                await _authNotifier.logout();
                              },
                              child: Icon(
                                Icons.exit_to_app,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
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
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Text(snapshot.data.toString());
                      } else {
                        return const Text('No movies found');
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
                                          width: 80.w,
                                          height: 120.h,
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
                      ElevatedButton(
                        onPressed: _isDisabled
                            ? null
                            : () async {
                                setState(() {
                                  _isDisabled = true; // Disable the button
                                });

                                final favList = await favouriteMoviesNotifier
                                    .getUserCurrentMovies();
                                List<String> favMovieTitles = [];
                                for (final movieTitle in favList) {
                                  favMovieTitles.add(movieTitle.title!);
                                }
                                if (favMovieTitles.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackBar(
                                      const Text(
                                          'Please Add Your Favourite Movies First'),
                                      Theme.of(context).colorScheme.error,
                                      context,
                                    ),
                                  );
                                  setState(() {
                                    _isDisabled = false; // Re-enable the button
                                  });
                                  return;
                                }

                                try {
                                  final String movieTitle =
                                      await getMovieNightRecommendation(
                                          favMovieTitles);

                                  showModalBottomSheet(
                                    useRootNavigator: true,
                                    context: context,
                                    builder: (context) => SheetSearch(
                                      movieTitle: movieTitle,
                                    ),
                                  );
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackBar(
                                      Text('Error: $error'),
                                      Theme.of(context).colorScheme.error,
                                      context,
                                    ),
                                  );
                                } finally {
                                  setState(() {
                                    _isDisabled = false; // Re-enable the button
                                  });
                                }
                              },
                        child: _isDisabled
                            ? const CircularProgressIndicator()
                            : const Text('AI Recommendation'),
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
