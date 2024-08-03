import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_connectt/pages/itempage.dart';

class Cushome extends StatelessWidget {
  Cushome({super.key});
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference reference = FirebaseFirestore.instance.collection('vendors');
    Stream<QuerySnapshot> stream = reference.snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('LC',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 30),),
        centerTitle: true,
        elevation: 0,

        forceMaterialTransparency: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 251, 247, 247),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mytextfield(
              //   hint: 'Search an item..',
              //   obscuretext: false,
              //   controll: search,
              // ),
              Text('All Products',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
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
                        childAspectRatio: 0.8, // Adjust the aspect ratio as needed
                      ),
                      itemCount: allProducts.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = allProducts[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
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
                            
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      '${data['iimage']}',
                                      height: 130,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                      
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0,top: 5),
                                  child: Text(
                                    '${data['iname']}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 2, 52, 94)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0,top: 0),
                                  child: Text(
                                    'Rs.${data['iprice']}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 44, 16, 203)
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
        bottom: false,
      ),
    
    );

  }
}
