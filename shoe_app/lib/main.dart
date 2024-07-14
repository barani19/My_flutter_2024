import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_app/bottom.dart';
import 'package:shoe_app/cartprovider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cartprovider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shoe App',
        home: Bottom(),
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow,primary: Colors.yellow),
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            bodyMedium: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600
            )
          ),
          useMaterial3: true,
        ),
      ),
    );
  }
}