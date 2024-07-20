// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_social/database/firestor.dart';
import 'package:minimal_social/utills/drawer.dart';

class Home extends StatelessWidget {
   Home({super.key});

final TextEditingController userpost = TextEditingController();
  void logout(){
    FirebaseAuth.instance.signOut();
  }

void postmsg(){
  if(userpost.text.isNotEmpty){
     database.addpost(userpost.text);

  }
       userpost.clear();
}
  Firestore database = Firestore();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Home',style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: logout,
              child: Icon(Icons.logout)),
          ),
        ],
      ),
      drawer: Mydrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextField(
                      controller: userpost,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'post something...'
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>postmsg(),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                      ),
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.all(20),
                      child: Icon(Icons.done)),
                  )
                ],
              ),
            ),
            StreamBuilder(stream: database.getpost(),
             builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              if(snapshot.hasError){
                return Center(child: Text('Error:${snapshot.error}'),);
              }
              if(!snapshot.hasData){
                return Center(child: Text('No posts add a new post...'),);
              }
               final posts = snapshot.data!.docs;
               return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context,index){
                    final post  = posts[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: Colors.white,
                        title: Text(post['post']),
                        subtitle: 
                            Text(post['email']),
                      ),
                    );
                  }));
             }
             )
          ],
        ),
      ),
    );
  }
}