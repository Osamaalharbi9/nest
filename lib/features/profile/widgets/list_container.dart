// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:nest/features/home/models/movie.dart';
// import 'package:nest/features/home/widgets/movie_card.dart';
// import 'package:nest/features/profile/providers/profile_provider.dart';

// class ListContainer extends ConsumerWidget {
//   const ListContainer({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final profileNotifier = ref.read(profileProvider.notifier);

//     return Container(
//       width: double.infinity,
//       height: 80,
//       color: Theme.of(context).colorScheme.onSurface,
//       child: FutureBuilder<List<Movie>>(
//         future: profileNotifier.fetchUserList(), // Ensure this returns List<Movie>
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator()); // Loading indicator
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No movies found'));
//           } else {
//             final movies = snapshot.data!;
//             return ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: movies.length < 4 ? movies.length : 4, // Ensure proper length
//               itemBuilder: (context, index) {
//                 return Text(
//                   movies[index].title
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
