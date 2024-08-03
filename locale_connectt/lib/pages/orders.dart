import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Vorders extends StatelessWidget {
  const Vorders({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference docref = FirebaseFirestore.instance.collection('vendors').doc(user?.email);
    Stream<DocumentSnapshot> stream = docref.snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder(stream: stream,
       builder: (context, snapshot) {
         if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
         }
         if(snapshot.hasError){
          return Center(child: Text('Error'),);
         }
          if(snapshot.hasData){
              Map<String,dynamic> vendor = snapshot.data!.data() as Map<String,dynamic>;
              List<Map<String,dynamic>> orders = List<Map<String,dynamic>>.from(vendor['orders']);
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              String pname = orders[index]['pname'];
              String price = orders[index]['price'];
              String pimage = orders[index]['pimage'];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white70,
                                border: Border.all(color: Color.fromARGB(255, 232, 244, 249)),
                                boxShadow: [
                                  new BoxShadow(
                                    color: const Color.fromARGB(255, 210, 207, 207),
                                    spreadRadius: 1,
                                    blurRadius: 5
                                  )
                                ]
                              ),
                  child: ListTile(
                    leading: Image.network(pimage,),
                     title: Text(pname),
                     subtitle: Text(price),
                  ),
                ),
              );
            },);
         }
         return Center(child: Text('No data'),);
       },
       ),

    );
  }
}