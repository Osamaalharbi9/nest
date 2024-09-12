import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nest/features/auth/views/loading_screen.dart';

class AuthViewModel extends StateNotifier<User?> {
  FirebaseAuth _auth;
  FirebaseFirestore _dataBase;
  AuthViewModel([FirebaseAuth? auth, FirebaseFirestore? dataBase])
      : _auth = auth ?? FirebaseAuth.instance,
        _dataBase = dataBase ?? FirebaseFirestore.instance,
        super(null) {
    _auth.authStateChanges().listen((user) => state = user);
  }
  Future<String> getUserEmail() async {
    try {
      var data =
          await _dataBase.collection('users').doc(_auth.currentUser!.uid).get();
      String loadedData = data.data()!['email'];
      return loadedData;
    } catch (e) {

      print(e);
      return '';
    }
  }
  Future <void>newUser(String email,String password)async{
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }
  Future<void> createNewUser(String username, String email, String password,
      BuildContext context) async {
    try {
      UserCredential userCredentials = await _auth
          .createUserWithEmailAndPassword(email: email, password: 'password');

      await _auth.currentUser!.sendEmailVerification();
      await _dataBase.collection('users').doc(userCredentials.user!.uid).set({
        'username': 'username',
        'email': email,
        'passwordUpdated': false,
        'urlImage': 'url'
      });
      await _dataBase
          .collection('lists')
          .doc(userCredentials.user!.uid)
          .set({'title': 'listtitle', 'list': []});

      state = userCredentials.user;
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('User created successfully'),
        backgroundColor: Colors.green,
      ));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoadingScreen()));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
    if (!mounted) return;
    // Navigator.pop(context);
    // Navigator.pop(context);
  }

//       Stream <bool>emailVerified()async{
//         try{
//           final data=await _dataBase.collection('users').doc(_auth.currentUser!.uid).get();
//           bool loadedData=data.data()!['']
//         }catch(e)
// {}      }
  Stream<bool> userVerified() async* {
    try {
      while (true) {
        // Reload the current user to get the latest information
        await _auth.currentUser!.reload();

        // Yield the current emailVerified state
        yield _auth.currentUser!.emailVerified;

        // Wait for a short duration before checking again
        await Future.delayed(
            Duration(seconds: 5)); // Adjust the interval as needed
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuth error: ${e.message}');
      yield false; // Yield false in case of an error
    } catch (e) {
      print('General error: $e');
      yield false; // Yield false in case of a general error
    }
  }

  Future<void> addUsernameAndPassword(String username, String password) async {
    try {
      await _auth.currentUser!.updatePassword(password);
      await _dataBase
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'username': username, 'passwordUpdated': true});
    } catch (e) {
      print(e);
    }
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('You\'re logged in!'),
        backgroundColor: Colors.green,
      ));
      state = userCredentials.user;
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    state = null;
  }

  FirebaseAuth get auth => _auth;
}

final authNotifier =
    StateNotifierProvider<AuthViewModel, User?>((ref) => AuthViewModel());
