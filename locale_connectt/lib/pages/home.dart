import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_connectt/utils/textfield.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController iname = TextEditingController();
  final TextEditingController iprice = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();

  String lat = '';
  String long = '';
  String imageurl = '';
  String updatedimage = '';
 User? user = FirebaseAuth.instance.currentUser;

  void livelocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      setState(() {
        lat = position.latitude.toString();
        long = position.longitude.toString();
      });
    });
  }

  Future<Position> getcurrentlocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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
      return Future.error('Location permissions are denied forever');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> addProducts() async {

    if (user != null) {
      DocumentReference docref = FirebaseFirestore.instance.collection('vendors').doc(user!.email);
      DocumentSnapshot usersnapshot = await docref.get();
      if (usersnapshot.exists) {
        List<dynamic> mapsList = usersnapshot.get('products') ?? [];

        mapsList.add({"iname": iname.text, "iprice": iprice.text, "iimage": imageurl.toString(), "ilat": lat, "ilong": long});
        await docref.update({'products': mapsList});
        setState(() {});
      }
    }
  }
 Future<void> updateProduct(int index, Map<String, dynamic> updatedProduct) async {
      if (user != null) {
        DocumentReference docref = FirebaseFirestore.instance.collection('vendors').doc(user!.email);
        DocumentSnapshot usersnapshot = await docref.get();
        if (usersnapshot.exists) {
          List<dynamic> products = usersnapshot.get('products') ?? [];
          if (index >= 0 && index < products.length) {
            products[index] = updatedProduct;
            await docref.update({'products': products});
            print('Product updated successfully.');
          }
        }
      }
    }
  Future<void> deleteProduct(int index) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference docref = FirebaseFirestore.instance.collection('vendors').doc(user.email);
      DocumentSnapshot usersnapshot = await docref.get();
      if (usersnapshot.exists) {
        List<dynamic> mapsList = usersnapshot.get('products') ?? [];
        mapsList.removeAt(index);
        await docref.update({'products': mapsList});
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference userdata = FirebaseFirestore.instance.collection('vendors');
    Stream<QuerySnapshot> stream = userdata.snapshots();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Vendor Home',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Map<String, dynamic>> mypdt = [];
          if (snapshot.hasData && snapshot.data != null) {
            for (var item in snapshot.data!.docs) {
              Map<String, dynamic> items = item.data() as Map<String, dynamic>;
              if (items.containsKey('products')&&items['email']== user!.email) {
                List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(items['products']);
                mypdt.addAll(products);
              }
            }
          }

          if (mypdt.isEmpty) {
            return Center(child: Text('No products available'));
          }

          return ListView.builder(
            itemCount: mypdt.length,
            itemBuilder: (context, index) {
              var ditem = mypdt[index];
              String pname = ditem['iname'] ?? 'No Name';
              String price = ditem['iprice'] ?? 'No Price';
              String pimage = ditem['iimage'] ?? '';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                    border: Border.all(color: Color.fromARGB(255, 232, 244, 249)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 210, 207, 207),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child:  ListTile(
                    leading: pimage.isNotEmpty ? Image.network(pimage) : Icon(Icons.image_not_supported),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: (){
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                               actions: [
                                SizedBox(height: 20,),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text('Update product',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),)),
                                SizedBox(height: 10,),
                                Mytextfield(hint: pname, obscuretext: false, controll: namecontroller),
                                SizedBox(height: 10,),
                                Mytextfield(hint: price, obscuretext: false, controll: pricecontroller),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('update image'),
                                    IconButton(onPressed: () async {
                                      ImagePicker image = ImagePicker();
                                      XFile? file = await image.pickImage(source: ImageSource.gallery);
                                      String unique = DateTime.now().millisecondsSinceEpoch.toString();
                                      Reference refernceroot = FirebaseStorage.instance.ref();
                                      Reference referdirimages = refernceroot.child('images');
                                      Reference refertoupload = referdirimages.child(unique);
                                      try {
                                        await refertoupload.putFile(File(file!.path));
                                        updatedimage = await refertoupload.getDownloadURL();
                                        print('Updated Image URL: $updatedimage');
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    icon: Icon(Icons.camera))
                                  ],
                                ),
                                ElevatedButton(onPressed: () async {
                                  // Handle the update logic here
                                  // Use the namecontroller and pricecontroller to get updated values
                                  String updatedName = namecontroller.text.isNotEmpty ? namecontroller.text : pname;
                                  String updatedPrice = pricecontroller.text.isNotEmpty ? pricecontroller.text : price;
                                  String updatedImage = updatedimage.isNotEmpty ? updatedimage : pimage;
                                  Map<String, dynamic> updatedProduct = {
                                    'iname': updatedName,
                                    'iprice': updatedPrice,
                                    'iimage': updatedImage,
                                    'ilat': ditem['ilat'],
                                    'ilong': ditem['ilong'],
                                  };

                                  // Update the product at the index
                                  await updateProduct(index, updatedProduct);

                                  // Clear the text controllers
                                  namecontroller.clear();
                                  pricecontroller.clear();
                                  updatedimage = '';

                                  // Close the dialog
                                  Navigator.pop(context);

                                  // Show a success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Product updated successfully!'))
                                  );
                                }, child: Text('Update'))
                              ],
                            );
                          });
                        }, icon: Icon(Icons.edit,color: Colors.blue,)),
                        IconButton(
                          onPressed: () async {
                            await deleteProduct(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Product deleted successfully!'))
                            );
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                    title: Text(
                      pname,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price: $price',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                );
          }
          );
        },
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AlertDialog(
                    actions: [
                      SizedBox(height: 20,),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Add Product',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 20),
                      Mytextfield(hint: 'Item Name', obscuretext: false, controll: iname),
                      SizedBox(height: 10),
                      Mytextfield(hint: 'Item Price', obscuretext: false, controll: iprice),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Add a product image'),
                          IconButton(
                            onPressed: () async {
                              ImagePicker image = ImagePicker();
                              XFile? file = await image.pickImage(source: ImageSource.gallery);
                              String unique = DateTime.now().millisecondsSinceEpoch.toString();
                              Reference refernceroot = FirebaseStorage.instance.ref();
                              Reference referdirimages = refernceroot.child('images');
                              Reference refertoupload = referdirimages.child(unique);
                              try {
                                await refertoupload.putFile(File(file!.path));
                                imageurl = await refertoupload.getDownloadURL();
                                setState(() {});
                              } catch (e) {
                                print(e);
                              }
                            },
                            icon: Icon(Icons.camera),
                          ),
                        ],
                      ),
                      ElevatedButton(
        
                        onPressed: () {
                          getcurrentlocation().then((value) {
                            setState(() {
                              lat = '${value.latitude}';
                              long = '${value.longitude}';
                            });
                          });
                          livelocation();
                          if (lat.isEmpty || long.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please insert a location or wait for a minute..')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location successfully uploaded..')));
                          }
                        },
                        child: Text('Add Location'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (imageurl.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please insert an image or wait for a minute..')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully uploaded..')));
                            addProducts();
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          icon: Icon(
            Icons.add,
            size: 40,
            color: Colors.black,
          ),
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
        ),
      ),
    );
  }
}
