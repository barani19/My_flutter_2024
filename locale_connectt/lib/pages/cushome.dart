import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locale_connectt/pages/itempage.dart';
import 'package:locale_connectt/utils/textfield.dart';

class Cushome extends StatelessWidget {
  Cushome({super.key});
  final TextEditingController search = TextEditingController();
  late String lat;
  late String long;
   void livelocation(){
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100
    );
    Geolocator.getPositionStream(
      locationSettings: locationSettings
    ).listen((Position position){
       lat = position.latitude.toString();
       long = position.longitude.toString();
        print('???????????$lat');
                  print('?????????????$long');
    }); 
  }

  @override
  Widget build(BuildContext context) {

         Future<Position> getcurrentlocation()async{
      bool servicenabled = await Geolocator.isLocationServiceEnabled();
      if(!servicenabled){
        return Future.error('Location service disabled');
      }
      LocationPermission permission = await  Geolocator.checkPermission();
      if(permission == LocationPermission.denied){
        permission = await Geolocator.requestPermission();
        if(permission == LocationPermission.denied){
          return Future.error('Location permissions are denied');
        }
      }
       if(permission == LocationPermission.deniedForever){
          return Future.error('Location permissions are denied forever we cant do anything');
        }
        return await Geolocator.getCurrentPosition();
    }
    
    
    CollectionReference reference = FirebaseFirestore.instance.collection('vendors');
    Stream<QuerySnapshot> stream = reference.snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('custhome'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Mytextfield(hint: 'search an item..', obscuretext: false, controll: search),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Unable to fetch data..'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No data available.'),
                    );
                  }

                  List<DocumentSnapshot> plist = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: plist.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = plist[index];
                      List<dynamic> products = document['products'];

                      return Container(
                        padding: EdgeInsets.all(10),
                        child: GridView.builder(
                          shrinkWrap: true, // Important to make the GridView shrink to the size of its content
                          physics: NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          itemCount: products.length,
                          itemBuilder: (context, productIndex) {
                            Map<String, dynamic> data = products[productIndex] as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 234, 228, 228)
                                ),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        getcurrentlocation();
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemPage(iname: data['iname'].toString(),)));
                                      },
                                      child: Image.network('${data['iimage']}', height: 130, width: 130, fit: BoxFit.cover,)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text('${data['iname']}', overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text('Rs.${data['iprice']}', overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
    );
  }
}
