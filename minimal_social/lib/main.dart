import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minimal_social/auth/auth.dart';
import 'package:minimal_social/firebase_options.dart';
import 'package:minimal_social/themes/dark.dart';
import 'package:minimal_social/themes/light.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Auth(),
      theme: lightmode,
      darkTheme: darkmode,
    );
  }
}