import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profilepage extends StatelessWidget {
    Profilepage({super.key});

   final User? currentuser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String,dynamic>>> getuserprofile() async{
    return await FirebaseFirestore.instance.collection('users').doc(currentuser!.email).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder(
        future: getuserprofile(),
         builder: (context,snapshot){
           // loading
           if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
           }
           // error
           else if(snapshot.hasError){
              return Center(
                child: Text('Errror:${snapshot.error}'),
              );
           }
           // retrieved data
           else if(snapshot.hasData){
            Map<String,dynamic>? profile = snapshot.data!.data();
            return Column(
              children: [
                Text(profile!['email']),
                Text(profile['username'])
              ],
            );
           }
           else{
            return Center(child: Text('No data'),);
           }
         }),
    );
  }
}