import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_connectt/utils/textfield.dart';

class Home extends StatelessWidget {
   Home({super.key});

 final  TextEditingController iname = TextEditingController();
  final  TextEditingController iprice = TextEditingController();
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
  
  String imageurl = '';
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
     Future<void> addProducts()async{
     User? user = FirebaseAuth.instance.currentUser;
     if(user!=null){
       DocumentReference docref = FirebaseFirestore.instance.collection('vendors').doc(user.email);
       DocumentSnapshot usersnapshot = await docref.get();
       if(usersnapshot.exists){
         List<dynamic> mapsList = usersnapshot.get('products') ?? [];

      // Update the list of maps (e.g., add a new map)
      mapsList.add({"iname": iname.text, "iprice": iprice.text,"iimage": imageurl.toString(),"ilat":lat,"ilong": long});

      // Write the updated list back to Firestore
      await docref.update({'products': mapsList});
      print('-----------------$imageurl');
       }
     }
  }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('vendorhome'),actions: [
      IconButton(onPressed: (){
        FirebaseAuth.instance.signOut();
      }, icon: Icon(Icons.logout))
    ],),
     floatingActionButton: IconButton(onPressed: (){
      showDialog(context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AlertDialog(
             actions: [
              Text('Add Product',style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Mytextfield(hint: 'item name', obscuretext: false, controll: iname),
              SizedBox(height: 10,),
               Mytextfield(hint: 'item price', obscuretext: false, controll: iprice),
               SizedBox(height: 10,),
               IconButton(onPressed: ()async{
                 ImagePicker image = ImagePicker();
                 XFile? file = await image.pickImage(source: ImageSource.gallery);
                 String unique = DateTime.now().millisecondsSinceEpoch.toString();
                 Reference refernceroot = FirebaseStorage.instance.ref();
                 Reference referdirimages = refernceroot.child('images');
                 Reference refertoupload = referdirimages.child(unique);
                 try{
                 await refertoupload.putFile(File(file!.path));
                 imageurl = await refertoupload.getDownloadURL();
                 print('====================$imageurl');
                 }catch(e){

                 }
               }, icon: Icon(Icons.camera)),
               ElevatedButton(onPressed: (){
                  getcurrentlocation().then((value){
                  lat = '${value.latitude}';
                  long = '${value.longitude}';
                  });
                  print('???????????$lat');
                  print('?????????????$long');
                  livelocation();
               }, child: Text('add location')),
               ElevatedButton(onPressed: (){
                if(imageurl.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('please insert a image or wait for a minute..'))
                  );
                }
                else{
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('successfully uploaded..'))
                  );
                addProducts();
                }
               }, child: Text('Submit'))
             ],
          ),
        );
      },
      );
     }, icon: Icon(Icons.add,size: 40, color: Colors.black,),
     color: Colors.amberAccent,style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.amberAccent)
     ),)
    );
  }
}

