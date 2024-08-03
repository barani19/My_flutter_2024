import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_connectt/Auth/cartprovider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
   CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  User? user = FirebaseAuth.instance.currentUser;

 Future<void> getUserDetails() async {
  try {
    // Reference to the "vendors" collection
    CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');
    
    // Fetch all documents in the collection
    QuerySnapshot snapshot = await vendors.get();
    
    // Loop through the documents and access data
    snapshot.docs.forEach((doc) {
      print('User ID: ${doc.id}');
      print('User Data: ${doc.data()}');
    });
  } catch (e) {
    print('Error fetching data: $e');
  }
}

  @override
  Widget build(BuildContext context) {
       double total = Provider.of<Cartprovider>(context,listen: false).money;
    var mycart = Provider.of<Cartprovider>(context).cart;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 30),),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(user?.email).get(),
        builder: (context, snapshot) {
           print(user?.email);
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasError){
            return Center(child: Text('no data'),);
          }
        if(snapshot.hasData){
          var data  = snapshot.data!.data() as Map<String, dynamic>;
          print(data);
         return Stack(
          children: [ 
            ListView.builder(
            itemCount: mycart.length,
            itemBuilder: (context, index) {
              var item = mycart[index];
              String panme = mycart[index]['pname'];
              String pimage = mycart[index]['pimage'];
              String price  = mycart[index]['price'];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    tileColor: const Color.fromARGB(255, 220, 213, 213),
                    leading: Image.network(pimage,height: 100,width: 100,),
                    trailing: IconButton(onPressed: (){
                      showDialog(context: context,
                      barrierDismissible: false,
                       builder: (context) {
                         return AlertDialog(
                          title: Text('Remvoe'),
                          content: Text('Are u sure want to delete?'),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text('No',style: TextStyle(color: Colors.green),)),
                            TextButton(onPressed: (){
                              Provider.of<Cartprovider>(context,listen: false).removemoney(double.parse(price));
                              total = Provider.of<Cartprovider>(context,listen: false).money;
                              Provider.of<Cartprovider>(context,listen: false).removeproduct(item);
                              Navigator.pop(context);
                              print(mycart);
                              print(total);
                            }, child: Text('Yes',style: TextStyle(color: Colors.red),)),
                          ],
                         );
                       },);
                    }, icon: Icon(Icons.delete,color: Colors.red,size: 30,)),
                    title: Text(panme),
                    subtitle: Text('Rs.$price'),
                  ),
                ),
              );
          },),
          Positioned(
            top: MediaQuery.of(context).size.height-250,
            child: Padding(
              padding: const EdgeInsets.only(),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 5
                    )
                  ],
                  color: Color.fromARGB(255, 241, 243, 251),
                  borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.only(top: 15,left: 20),
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text('TOTAL: Rs.$total',style: TextStyle(
                        fontSize: 20,fontWeight: FontWeight.bold
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(onPressed: (){
                          Provider.of<Cartprovider>(context,listen: false).updateorder(mycart);
                          FirebaseFirestore.instance.collection('users').doc(user!.email).update({
                            'username': data['username'],
                            'email': data['email'],
                            'role': data['role'],
                            'password': data['password'],
                            'ordered': Provider.of<Cartprovider>(context,listen: false).order
                        });
                         // Add the order to the vendor's collection
                         
                                  for (var item in mycart) {
                                    String vendorId = item['email']; // Get vendorId from the cart item
                                     DocumentReference vendorRef = FirebaseFirestore.instance.collection('vendors').doc(vendorId);
              
                                   vendorRef.update({ 
                                    'orders': FieldValue.arrayUnion([item])
                                  });
                                  }
                                  
                          Provider.of<Cartprovider>(context,listen: false).removeall();
                          print(Provider.of<Cartprovider>(context,listen: false).order);
                      }, child: Text('Order now')),
                    ),
                  ],
                ),
              ),
            ),
          )
          ]
        );
        }
         return Center(child: Text('erroe'),);
        }
        
      ),

      
    );
  }
}