// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

//GLOBAL VARIABLES
String? email;
String? password;
String? confirmPassword;
bool isLoading = false;
bool isPasswordVisible = false;
bool isConfirmPasswordVisible = false;

//FIREBASE AUTH
Future<User?> signInWithGoogle() async {
  try {
    // Ensure the user is signed out before a new sign-in attempt
    await googleSignIn.signOut();

    // Trigger Google Sign-In process
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    // Check if the user canceled the sign-in
    if (googleSignInAccount == null) {
      print('Google sign-in process was canceled.');
      throw Exception('Google sign-in canceled by user.');
    }

    // Obtain authentication details from the Google account
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    // Create Google credentials for Firebase
    AuthCredential authCredential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    // Sign in with Firebase using the Google credentials
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(authCredential);

    // Return the signed-in user
    return userCredential.user;
  } catch (e) {
    print('Error in Google sign-in: $e');
    throw e;
  }
}

Future<UserCredential> regisretUser() async {
  return await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email!,
    password: password!,
  );
}

Future<void> loginUser() async {
  UserCredential user = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email!, password: password!);
}

Future<bool> checkIfUserExists(String uid) async {
  try {
    // Assuming you're using Firebase Firestore
    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return docSnapshot.exists;
  } catch (e) {
    print('Error checking if user exists: $e');
    return false;
  }
}
