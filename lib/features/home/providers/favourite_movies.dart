import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest/features/home/models/favourite_movies.dart';
import 'package:nest/features/home/models/movie.dart';

class FavouriteMovies extends StateNotifier<FavouriteMoviesState> {
  final FirebaseFirestore _dataBase;
  final FirebaseAuth _auth;

  FavouriteMovies([FirebaseFirestore? dataBase, FirebaseAuth? auth])
      : _auth = auth ?? FirebaseAuth.instance,
        _dataBase = dataBase ?? FirebaseFirestore.instance,
        super(FavouriteMoviesState(movies: {}, movieExists: false));
        Future <List<Movie>> getUserCurrentMovies()async{
       final data=  await _dataBase.collection('lists').doc(_auth.currentUser!.uid).get();
       final List<Movie>currentList=data.data()!['list'];
       return currentList;
        }
  Future<void> addFavouriteMovie(Movie movie,BuildContext context) async {
    await _checkIfMovieExists(movie);

    if (!state.movieExists) {
      try {
        final data = await _dataBase.collection('lists').doc(_auth.currentUser!.uid).get();
        final List<dynamic> loadedData = data.data()?['list'] ?? [];

        loadedData.add(movie.toJson());
        await _dataBase.collection('lists').doc(_auth.currentUser!.uid).set({
          'title': _auth.currentUser!.email,
          'list': loadedData,

        });
        
        state = state.copyWith(
          movies: {...state.movies, movie},
          movieExists: false,  // Reset the flag after adding
        );
        ScaffoldMessenger.of(context).clearSnackBars();
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: content));
        print('Movie has been added');
      } catch (e) {
        print('Error adding movie: $e');
      }
    } else {
      // Movie exists, so remove it from Firestore and the local state
      try {
        final data = await _dataBase.collection('lists').doc(_auth.currentUser!.uid).get();
        final List<dynamic> loadedData = data.data()?['list'] ?? [];

        // Remove the movie from the list
        loadedData.removeWhere((item) => movie.id == item['id']);

        // Update Firestore with the new list
        await _dataBase.collection('lists').doc(_auth.currentUser!.uid).set({
          'title': _auth.currentUser!.email,
          'list': loadedData,
        });

        // Update the local state
        final updatedMovies = {...state.movies}..removeWhere((item) => item.id == movie.id);
        state = state.copyWith(movies: updatedMovies, movieExists: false);

        print('Movie has been deleted');
      } catch (e) {
        print('Error deleting movie: $e');
      }
    }
  }

  Future<void> checkIfMovieExists(Movie movie) async {
    await _checkIfMovieExists(movie);
  }

  Future<void> _checkIfMovieExists(Movie movie) async {
    try {
      final data = await _dataBase.collection('lists').doc(_auth.currentUser!.uid).get();
      final List<dynamic> loadedData = data.data()?['list'] ?? [];

      bool movieExists = loadedData.any((item) => movie.id == item['id']);

      state = state.copyWith(movieExists: movieExists);
    } catch (e) {
      print('Error checking movie: $e');
    }
  }
}

final favouriteMoviesProvider =
    StateNotifierProvider<FavouriteMovies,FavouriteMoviesState>(
        (ref) => FavouriteMovies());
