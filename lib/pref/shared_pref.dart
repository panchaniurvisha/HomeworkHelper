import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static String email = "email";
  static String displayName = "displayName";
  static String photoImage = "photoUrl";
  static String islogin = "isLoggedIn";
  static String isAdminlogin = "isAdminLoggedIn";
  static String isTeacherlogin = "isTeacherLoggedIn";

  static Future<void> saveEmail(String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(email, data);
  }

  static Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(email);
  }

  static Future<void> saveDisplayName(String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(displayName, data);
  }

  static Future<String?> getDisplayName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayName);
  }

  static Future<void> saveProfieUrl(String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(photoImage, data);
  }

  static Future<String?> getPhotourl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(photoImage);
  }

  static setIsloggin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(islogin, true);
  }

  static Future<bool> getisLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(islogin) ?? false;
  }

  static setIsAdminloggin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isAdminlogin, true);
  }

  static Future<bool> getisAdminLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log('adminLofin===>$isAdminlogin');
    return prefs.getBool(isAdminlogin) ?? false;
  }

  static setIsTeacherloggin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isTeacherlogin, true);
  }

  static Future<bool> getisTeacherLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log('adminLofin===>$isAdminlogin');
    return prefs.getBool(isTeacherlogin) ?? false;
  }
}
