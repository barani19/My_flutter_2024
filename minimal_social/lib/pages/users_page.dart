import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Userpage extends StatelessWidget {
  const Userpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: StreamBuilder (
        stream:  FirebaseFirestore.instance.collection('users').snapshots(),
         builder: (context,snapshot){
            if(snapshot.hasError){
              return Center(child: Text('Error:${snapshot.error}'),);
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if(!snapshot.hasData){
              return Center(child: Text('NO data'),);
            }

            final users  = snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context,index){
                final user  =  users[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          tileColor: Colors.white,
                    title: Text(user['email']),
                    subtitle: Text(user['username']),
                  ),
                );
              });
         }),
    );
  }
}