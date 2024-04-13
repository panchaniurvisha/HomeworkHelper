import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homeworkhelper/pref/shared_pref.dart';
import 'package:homeworkhelper/screen/login_screen.dart';
import 'package:homeworkhelper/screen/main_home_screen.dart';

enum UserType { admin, teacher }

class LoginController extends GetxController {
  var isObscure = true.obs;
  var isHidden = true.obs;
  RxBool isAdmin = true.obs;

  void toggleAdmin(bool value) {
    isAdmin.value = value;
  }

  final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final passwordValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  final formKey = GlobalKey<FormState>().obs;
  final emailController = TextEditingController().obs;

  Rx<User?> firebaseUser = Rx<User?>(null);
  // RxBool isAdmin = false.obs;
  Rx<UserType> userType = UserType.teacher.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn1 = GoogleSignIn(scopes: ['email', 'profile']);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  Future<void> googleSignIn(BuildContext context, UserType type) async {
    isLoading.value = true;
    try {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);
        await googleSignIn1.signInSilently();

        final user = userCredential.user;
        String collection = type == UserType.admin ? 'Admin' : 'Teacher';
        if (user != null) {
          var document =
              await _firestore.collection('Admin').doc(user.uid).get();

          var documentTeacher =
              await _firestore.collection('Teacher').doc(user.uid).get();

          if (collection == 'Teacher') {
            if (documentTeacher.exists) {
              if (documentTeacher['role'] == collection) {
                // SharedPref.setIsAdminloggin();
                // SharedPref.setIsloggin();
                SharedPref.setIsTeacherloggin();
                addUserToFirestore(user, type);

                Get.to(const MainHomeScreen());
              } else {
                Get.snackbar('Alert', 'You are not teacher',
                    backgroundColor: Colors.black,
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.white);

                isLoading.value = false;
              }
            } else {
              Get.snackbar('Alert', 'You are data not available',
                  backgroundColor: Colors.black,
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white);
              // addUserToFirestore(user, type);
            }
          } else {
            if (document.exists) {
              if (document['role'] == collection) {
                SharedPref.setIsAdminloggin();

                addUserToFirestore(user, type);

                Get.to(const MainHomeScreen());
                isLoading.value = false;
              }
            } else {
              Get.snackbar('Alert', 'You are not admin',
                  backgroundColor: Colors.black,
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white);

              // addUserToFirestore(user, type);

              isLoading.value = false;
            }
          }
        }
      } catch (e) {
        debugPrint('$e');
      } finally {
        isLoading.value = false;
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleSignOut() async {
    await _auth.signOut();

    await googleSignIn1
        .signOut()
        .whenComplete(() => Get.off(const LoginScreen()));

    debugPrint("User signed out of Google account");
  }

  Future<void> addUserToFirestore(User? user, UserType type) async {
    String collection = type == UserType.admin ? 'Admin' : 'Teacher';
    await _firestore.collection(collection).doc(user?.uid).set({
      'uID': user?.uid,
      'displayName': user?.displayName,
      'email': user?.email,
      'profileImage': user?.photoURL,
      'role': collection
      // Add more user details if necessary
    }).then((value) {});
  }

  Future<String> getUserRole(String uid) async {
    DocumentSnapshot adminDoc =
        await FirebaseFirestore.instance.collection('Admin').doc(uid).get();
    if (adminDoc.exists) {
      return 'Admin';
    }

    DocumentSnapshot teacherDoc =
        await FirebaseFirestore.instance.collection('Teacher').doc(uid).get();
    if (teacherDoc.exists) {
      return 'Teacher';
    }

    return ''; // If user not found in either collection
  }
}
