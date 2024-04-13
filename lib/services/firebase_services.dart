// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homeworkhelper/controller/login_controller.dart';
import 'package:homeworkhelper/pref/shared_pref.dart';
import 'package:homeworkhelper/screen/login_screen.dart';
import 'package:homeworkhelper/screen/main_home_screen.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  LoginController loginController = LoginController();
  User? user;
  RxBool isLoggedIn = false.obs;
  // Sign in with Google

  /*  signInWithGoogle1(
    BuildContext context,
    UserType? userType
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing the dialog
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    await Firebase.initializeApp();

    // The `GoogleAuthProvider` can only be used while running on the web
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential =
          await _auth.signInWithPopup(authProvider);

      user = userCredential.user;
    } catch (e) {
      debugPrint('$e');
    }

    if (user != null) {
      await _firestore.collection('Teacher').doc(user?.uid).set({
        'uID': user?.uid,
        'displayName': user?.displayName,
        'email': user?.email,
        'profileImage': user?.photoURL,
        
      }).then((value) {
        SharedPref.setIsloggin();

        Get.to(const MainHomeScreen());
      });
    }

    return user;
  }
 */
  Future<UserCredential> signInWithApple() async {
    await Firebase.initializeApp();

    // Create and configure an OAuthProvider for Sign In with Apple.
    final provider = OAuthProvider("apple.com")
      ..addScope('email')
      ..addScope('name');

    final UserCredential userCredential = await _auth.signInWithPopup(provider);

    user = userCredential.user;

    await _firestore.collection('Teacher').doc(user?.uid).set({
      'displayName': user?.displayName,
      'email': user?.email,
    });

    // Sign in the user with Firebase.
    return await FirebaseAuth.instance.signInWithPopup(provider);
  }

  /* signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // webAuthenticationOptions: WebAuthenticationOptions(
        //   clientId: 'YOUR_CLIENT_ID',
        //   redirectUri: Uri.parse('https://your-redirect-uri.com'),
        // ),
      );

      OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      final AuthCredential authCredential = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(authCredential);
      final User? user = userCredential.user;

      await _firestore.collection('User').doc(user?.uid).set({
        'displayName': user?.displayName,
        'email': user?.email,
      });
    } catch (error) {
      debugPrint('Failed to sign in with Apple: $error');
    }
  }
 */

  checkAndCreateUser(String email, BuildContext context) async {
    log('Emailaddresssss====>$email');
    final QuerySnapshot<Map<String, dynamic>> result = await _firestore
        .collection('Teacher')
        .where('email', isEqualTo: email)
        .get();

    log('resulLogin====>${result.docs}');

    if (result.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('This Email is Not Available'),
        backgroundColor: Colors.black,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
      ));

      debugPrint('This Email is Not Available');

      // await _firestore.collection('users').add({'email': email});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Login Successfully'),
        backgroundColor: Colors.black,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
      ));

      Get.off(const MainHomeScreen());

      // if (email != _auth.currentUser?.email) {}

      loginController.emailController.value.text = '';
    }
  }

  // signOutGoogle() async {
  //   await _auth.signOut();

  //   await _googleSignIn
  //       .signOut()
  //       .whenComplete(() => Get.off(const LoginScreen()));

  //   debugPrint("User signed out of Google account");
  // }
}
