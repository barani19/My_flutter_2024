import 'package:flutter/material.dart';
import 'package:spotify_ui/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  splash(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
    );
  }
}