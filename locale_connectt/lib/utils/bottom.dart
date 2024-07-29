import 'package:flutter/material.dart';
import 'package:locale_connectt/pages/cartpage.dart';
import 'package:locale_connectt/pages/cushome.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int current  = 0;
    List<Widget> pages = [
    Cushome(),
    CartPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: IndexedStack(
        index: current,
        children: pages
      ),
     bottomNavigationBar:  BottomNavigationBar(
      currentIndex: current,
      onTap: (value) {
        setState(() {
          current = value;
        });
      },
        iconSize: 40,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary
        ),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: ''),
         BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: '')
      ]),
    );
  }
}