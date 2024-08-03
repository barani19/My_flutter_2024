import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locale_connectt/Auth/cartprovider.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    var mycart = Provider.of<Cartprovider>(context).order;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Page',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 30),),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Unable to fetch data'));
          }
          if (snapshot.hasData) {
            List<DocumentSnapshot> documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = documents[index];
                Map<String, dynamic> userData = document.data() as Map<String, dynamic>;

                // Check if 'ordered' field exists and is a list
                if (userData.containsKey('ordered') && userData['ordered'] is List) {
                  List<dynamic> orders = userData['ordered'];

                  return Column(
                    children: orders.map((order) {
                      // Ensure each order item is a map
                      if (order is Map<String, dynamic>) {
                        String panme = order['pname'] ?? 'Unknown';
                        String pimage = order['pimage'] ?? '';
                        String price = order['price'] ?? '0';
                        return Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 10),
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
                                  borderRadius: BorderRadius.circular(20)),
                              tileColor: const Color.fromARGB(255, 220, 213, 213),
                              leading: Image.network(
                                pimage,
                                height: 100,
                                width: 100,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                              ),
                              title: Text(panme,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 2, 52, 94)
                                    ),),
                              subtitle: Text('Rs.$price', style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 44, 16, 203)
                                    ),),
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }).toList(),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text('No orders found'),
                    ),
                  );
                }
              },
            );
          }
          return Center(child: Text('No data available'));
        },
      ),
    );
  }
}
