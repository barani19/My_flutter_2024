import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locale_connectt/pages/cartitem.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ItemPage extends StatefulWidget {
  final String iname;

  ItemPage({Key? key, required this.iname}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  double? lat;
  double? long;

  @override
  void initState() {
    super.initState();
    getcurrentlocation();
    _initializeLocation();
  }

  Future<Position> getcurrentlocation() async {
    bool servicenabled = await Geolocator.isLocationServiceEnabled();
    if (!servicenabled) {
      return Future.error('Location service disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied forever; we can\'t do anything');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _initializeLocation() async {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;
      });
    });
  }

  Future<void> openMap(double lat, double long) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await launchUrlString(googleUrl);
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference reference = FirebaseFirestore.instance.collection('vendors');
    Stream<QuerySnapshot> stream = reference.snapshots();
   String? pname;
    return Scaffold(
      appBar: AppBar(
        title: Text('Item'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          List<dynamic> products = [];
          List<Map<String, dynamic>> locations = [];

          for (var document in plist) {
            // Get email if available
            String? email = document['email'];

            // Get products if available
            if (document['products'] != null) {
              var productList = document['products'] as List<dynamic>;
              for (var product in productList) {
                // Ensure each product is a Map<String, dynamic>
                if (product is Map<String, dynamic>) {
                  products.add({
                    ...product,
                    'email': email
                  });
                }
              }
            }
          }
     
          // Process products and find matching items
          for (var product in products) {
            var data = product as Map<String, dynamic>;
            if (data['iname'] == widget.iname && data['ilat'] != null && data['ilong'] != null && data['iimage'] != null) {
              double ilat = double.tryParse(data['ilat'].toString()) ?? 0.0;
              double ilong = double.tryParse(data['ilong'].toString()) ?? 0.0;
              Location l = Location(ilat, ilong);

              locations.add({
                'email': data['email'],
                'iname': data['iname'],
                'image': data['iimage'],
                'price': data['iprice'],
                'location': l
              });
            }
          }

          // Sort locations by distance from the current location
          if (lat != null && long != null) {
            Location referenceLocation = Location(lat!, long!);
            locations.sort((a, b) =>
                haversineDistance(referenceLocation, a['location']).compareTo(haversineDistance(referenceLocation, b['location'])));
          }

          return ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              var locationData = locations[index];
              String price = locationData['price'];
              Location location = locationData['location'];
              String imageUrl = locationData['image'];
              String email = locationData['email'] ?? 'No email available';
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_)=>Cartitem(
                     pimage: imageUrl,
                     pname: locationData['iname'],
                     price: price,
                     email: email,
                     lat: location.latitude,
                     long: location.longitude,
                     product: products,
                  ))
                ),
                // onTap: () => openMap(location.latitude, location.longitude),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ) ,
                    tileColor: Color.fromARGB(255, 237, 229, 238),
                    leading: imageUrl != null ? Image.network(imageUrl,height: 100,width: 100,fit: BoxFit.cover,) : null,
                    title: Text('${location.latitude}, ${location.longitude}'),
                    subtitle: Text(email),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Location {
  double latitude;
  double longitude;

  Location(this.latitude, this.longitude);
}

// Calculate the distance between two points using the Haversine formula
double haversineDistance(Location loc1, Location loc2) {
  const double R = 6371; // Radius of the Earth in km
  double latDistance = (loc2.latitude - loc1.latitude) * pi / 180;
  double lonDistance = (loc2.longitude - loc1.longitude) * pi / 180;
  double a = sin(latDistance / 2) * sin(latDistance / 2) +
      cos(loc1.latitude * pi / 180) * cos(loc2.latitude * pi / 180) *
      sin(lonDistance / 2) * sin(lonDistance / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c; // Distance in km
}
