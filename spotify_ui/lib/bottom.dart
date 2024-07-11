import 'package:flutter/material.dart';
import 'package:spotify_ui/HomePage.dart';
import 'package:spotify_ui/fav.dart';
import 'package:spotify_ui/search.dart';

class bottom extends StatefulWidget {
  const bottom({super.key});

  @override
  State<bottom> createState() => _bottomState();
}

class _bottomState extends State<bottom> {
  
   PageController _current = new PageController();
   int _val = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         body: PageView(
            controller: _current,
            children: [
                 HomePage(),
                  search(),
                  Fav(),
                  Icon(Icons.person)
            ],
         ),
          bottomNavigationBar: BottomNavigationBar(
        currentIndex: _val,
        showSelectedLabels: true,
        selectedItemColor: Colors.white,
        showUnselectedLabels: true,
        unselectedLabelStyle: TextStyle(
          color: Color.fromARGB(255, 208, 189, 189)
        ),
        unselectedItemColor: Color.fromARGB(255, 152, 136, 136),
        onTap: (int value) {
          setState(() {
             _val = value;
          });
          _current.jumpToPage(_val);
        },
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_filled),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: 'Favourites',
            icon: Icon(Icons.favorite_border),
          ),
          BottomNavigationBarItem(
            label: 'Premium',
            icon: Icon(Icons.person),
          ),
        ]
        ),
    ); 
   
  }
}