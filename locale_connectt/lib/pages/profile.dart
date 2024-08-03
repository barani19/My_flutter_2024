
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String name = "Roan Atkinson";
  String email = "roanatkinson@gmail.com";
  XFile? selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildProfileDetails(),
          SizedBox(height: 20),
          _buildPreferences(),
        ],
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 75,
            backgroundImage: selectedImage == null
                ? NetworkImage('https://firebasestorage.googleapis.com/v0/b/new-conect-ca7f0.appspot.com/o/images%2F1722139379823?alt=media&token=3fbbbd05-16f3-4ce4-b7ba-5f163a0f1a38')
                : FileImage(File(selectedImage!.path)),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.add_circle,
                size: 30,
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        Text(name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        Text(email,style: TextStyle(fontSize: 15,),),
         Container(
          width: double.infinity,
          child: Image.asset(
            'lib/assets/image-removebg-preview.png',
            fit: BoxFit.cover,
            scale: Checkbox.width,
          ),
        ),
      ],
    );
  }

 Widget _buildPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10,bottom: 20),
          child: Text(
            'Preferences',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildPreferenceBox(Icons.store, 'Add',Colors.blue),
            _buildPreferenceBox(Icons.favorite, 'wishlist',Colors.red),
            _buildPreferenceBox(Icons.monetization_on, 'Orders',Colors.amber),
          ],
        ),
      ],
    );
  }

  Widget _buildPreferenceBox(IconData icon, String label,Color color) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 50,color: color,),
          ),
          SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      child: Container(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                Icon(Icons.account_circle,size: 30,),
                SizedBox(width: 20),
                Text('Edit Profile', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}