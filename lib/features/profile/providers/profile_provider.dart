import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest/features/home/models/movie.dart';

class ProfileProvider extends StateNotifier<List<Movie>> {
  FirebaseFirestore _dataBase;
  FirebaseAuth _auth;
  ProfileProvider([FirebaseFirestore? dataBase, FirebaseAuth? auth])
      : _auth = auth ?? FirebaseAuth.instance,
        _dataBase = dataBase ?? FirebaseFirestore.instance,
        super([]);
  Future<int> viewStats() async {
    try {
      final data =
          await _dataBase.collection('lists').doc(_auth.currentUser!.uid).get();

      if (data.exists && data.data() != null) {
        final List<dynamic>? loadedData = data.data()?['list'];
        if (loadedData != null) {
          return loadedData.length;
        }
      }
      return 0;
    } catch (e) {
      print('Error fetching view stats: $e');
      return 0;
    }
  }

  Future<List<Movie>> fetchUserList() async {
  final data = await _dataBase.collection('lists').doc(_auth.currentUser!.uid).get();
  final List<dynamic> loadedData = data.data()?['list'] ?? [];

  // Convert dynamic list to List<Movie>
  return loadedData.map((item) => Movie.fromJson(item)).toList();
}

}

final profileProvider = StateNotifierProvider<ProfileProvider, List<Movie>>(
    (ref) => ProfileProvider());
