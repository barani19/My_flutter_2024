import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firestore{
   User? users = FirebaseAuth.instance.currentUser;
   CollectionReference posts = FirebaseFirestore.instance.collection('posts');
   Future<void> addpost(String post) {
      return posts.add({
        'email': users!.email,
        'post': post,
        'timestamp': Timestamp.now()
      });
   }
   Stream<QuerySnapshot> getpost(){
    final mypost  = posts.orderBy('timestamp',descending: true).snapshots();
    return mypost;
   }
}