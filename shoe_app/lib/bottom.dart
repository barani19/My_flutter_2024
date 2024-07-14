import 'package:flutter/material.dart';
import 'package:shoe_app/Home.dart';
import 'package:shoe_app/cart.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int current  = 0;
  List<Widget> pages = [
    Home(),
    cart()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: current,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: current,
        onTap: (value) {
          setState(() {
            current = value;
          });
        },
        iconSize: 30,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary
        ),
        items: const[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '' 
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.shopping_cart))
        ]),
    );
  }
}