import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_social/pages/profile_pages.dart';
import 'package:minimal_social/pages/users_page.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(
         children: [
          DrawerHeader(
            child: Icon(Icons.favorite,color: Theme.of(context).colorScheme.inversePrimary,)
            ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.home,color: Theme.of(context).colorScheme.inversePrimary,),
                    title: Text('H O M E'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.person,color: Theme.of(context).colorScheme.inversePrimary,),
                title: Text('P R O F I L E'),
                 onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> Profilepage()));
                    },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.group,color: Theme.of(context).colorScheme.inversePrimary,),
                title: Text('U S E R S'),
                 onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> Userpage()));
                    },
              ),
            ),
             
              ]
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.logout,color: Theme.of(context).colorScheme.inversePrimary,),
                title: Text('L O G O U T'),
                 onTap: () {
                      Navigator.pop(context);
                      FirebaseAuth.instance.signOut();
                    },
              ),
            ),
        ],
      ),
        
    );
  }
}