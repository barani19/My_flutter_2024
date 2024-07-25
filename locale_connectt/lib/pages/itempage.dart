import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
    _initializeLocation();
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
    // if (await canLaunchUrlString(googleUrl)) {
      await launchUrlString(googleUrl);
    // } else {
    //   throw 'Could not launch $googleUrl';
    // }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference reference = FirebaseFirestore.instance.collection('vendors');
    Stream<QuerySnapshot> stream = reference.snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Item'),
        centerTitle: true,
      ),
      body: StreamBuilder(
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
          List<dynamic>? products;
          Map<String, dynamic> data;
          List<Location> locations = [];

          for (int i = 0; i < plist.length; i++) {
            DocumentSnapshot document = plist[i];
            products = document['products'];
          }

          if (products != null) {
            for (int j = 0; j < products.length; j++) {
              data = products[j] as Map<String, dynamic>;

              if (data['iname'] == widget.iname && data['ilat'] != null && data['ilong'] != null) {
                double ilat = double.tryParse(data['ilat'].toString()) ?? 0.0;
                double ilong = double.tryParse(data['ilong'].toString()) ?? 0.0;
                Location l = Location(ilat, ilong);
                locations.add(l);
              }
            }
          }

          if (lat != null && long != null) {
            Location referenceLocation = Location(lat!, long!);

            locations.sort((a, b) => haversineDistance(referenceLocation, a).compareTo(haversineDistance(referenceLocation, b)));
          }

          return ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              Location location = locations[index];
              return GestureDetector(
                onTap: () => openMap(location.latitude, location.longitude),
                child: ListTile(
                  title: Text('${location.latitude}, ${location.longitude}'),
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
