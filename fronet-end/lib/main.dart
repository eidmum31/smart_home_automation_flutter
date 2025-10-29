import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobileplatformfinal/auth/auth.dart';
import 'package:mobileplatformfinal/auth/login_or_register.dart';
import 'package:mobileplatformfinal/pages/login_page.dart';
import 'package:mobileplatformfinal/pages/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:FirebaseOptions(apiKey: "AIzaSyAT2eUFGrYwOT5nXAxkkzqw35CB7OJavqE",
        authDomain: "mobile-platform-36bdd.firebaseapp.com",
        projectId: "mobile-platform-36bdd",
        storageBucket: "mobile-platform-36bdd.appspot.com",
        messagingSenderId: "556320899617",
        appId: "1:556320899617:web:36ee80645ea9a545fed960"),
  );
  runApp(const MyApp()

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
