import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_connectt/pages/cushome.dart';
import 'package:locale_connectt/pages/home.dart';
import 'package:locale_connectt/pages/loginorreg.dart';

class Rolebased extends StatelessWidget {
  const Rolebased({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user?.email).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data != null) {
          var userData = snapshot.data?.data() as Map<String, dynamic>;
          if (userData.containsKey('role')) {
            var role = userData['role'];
            if (role == 'vendor') {
              return Home();
            } else if (role == 'user') {
              return Cushome();
            }else{
              return Loginorreg();
            }
          }
        }
         return Center(child: Text('unknown error'),);        
      },
    );
  }
}