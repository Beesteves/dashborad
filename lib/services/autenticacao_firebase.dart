import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // For Web: clientId opcional aqui, se não usar meta tag
    clientId: kIsWeb
      ? '196444884479-kn6hnvgbr5gav32jhftifam0nu2u7teg.apps.googleusercontent.com'
      : null,
  );

  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final cred = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(cred);
    return userCred.user;
  }

  Future<bool> isFirstLogin(String uid) async {
    final doc = await _db.collection('usuarios').doc(uid).get();
    return !doc.exists;
  }

  Future<void> salvarChave(String uid, String iD) async {
    await _db.collection('usuarios').doc(uid).set({
      'iD': iD,
      'email': FirebaseAuth.instance.currentUser?.email,
    });
  }

  Future<String?> getChave(String uid) async {
    final doc = await _db.collection('usuarios').doc(uid).get();
    return doc.data()?['iD'];
  }
}
