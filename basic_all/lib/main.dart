import 'package:flutter/material.dart';

import 'CurrencyConvertor.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
     const MyApp({super.key});
     
     Widget build(BuildContext context){
      return MaterialApp(
         home: const CurrencyConvertor(),
      );
     }
}

