import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_connectt/pages/itempage.dart';
import 'package:locale_connectt/utils/textfield.dart';

class Cushome extends StatelessWidget {
  Cushome({super.key});
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference reference = FirebaseFirestore.instance.collection('vendors');
    Stream<QuerySnapshot> stream = reference.snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Home'),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Mytextfield(
                hint: 'Search an item..',
                obscuretext: false,
                controll: search,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Unable to fetch data..'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No data available.'));
                    }
          
                    List<DocumentSnapshot> plist = snapshot.data!.docs;
                    List<Map<String, dynamic>> allProducts = [];
          
                    // Aggregate all products from each document into a single list
                    for (var document in plist) {
                      List<dynamic> products = document['products'];
                      for (var product in products) {
                        allProducts.add(product as Map<String, dynamic>);
                      }
                    }
          
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        childAspectRatio: 0.85, // Adjust the aspect ratio as needed
                      ),
                      itemCount: allProducts.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = allProducts[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(255, 234, 228, 228),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ItemPage(
                                          iname: data['iname'].toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    '${data['iimage']}',
                                    height: 130,
                                    width: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0,top: 5),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '${data['iname']}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Rs.${data['iprice']}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
