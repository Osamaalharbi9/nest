import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthViewModel extends StateNotifier<User?> {
  FirebaseAuth _auth;
  FirebaseFirestore _dataBase;
  AuthViewModel([FirebaseAuth? auth, FirebaseFirestore? dataBase])
      : _auth = auth ?? FirebaseAuth.instance,
        _dataBase = dataBase ?? FirebaseFirestore.instance,
        super(null) {
    _auth.authStateChanges().listen((user) => state = user);
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
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pop(context);
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const BottomNavigator()),  (Route<dynamic> route) => false);
  }

  Future<bool> userUpdatedPassword() async {
    try {
      final data =
          await _dataBase.collection('users').doc(_auth.currentUser!.uid).get();
      final bool loadedData = data.data()!['passwordUpdated'];
      print(loadedData);
      return loadedData;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
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
