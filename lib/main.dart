import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/screen/main_home_screen.dart';
import 'package:homeworkhelper/utils/app_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyDBTG70hnyhwUgYym6lh3hJILI0JWSNNhs",
              authDomain: "h-journal.firebaseapp.com",
              projectId: "h-journal",
              storageBucket: "h-journal.appspot.com",
              messagingSenderId: "297234085659",
              appId: "1:297234085659:web:9828bf1787dba5e827c5be",
              measurementId: "G-R4703G2G8S"));
    } else {
      Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        builder: (context, child) =>
            MediaQuery(data: MediaQuery.of(context).copyWith(), child: child!),
        title: 'Homework Helper',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.whiteColor,
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            fontFamily: "Poppins"),
        debugShowCheckedModeBanner: false,
        home: MainHomeScreen());
  }
}

/* FutureBuilder<bool>(
        home: LoginScreen()
        /*  FutureBuilder<bool>(
        future: SharedPref.getisLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Or any other loading indicator
          } else {
            final bool isLoggedIn = snapshot.data ?? false;
            return isLoggedIn ? const MainHomeScreen() : const LoginScreen();
          }
        },
      ), */
        );*/
