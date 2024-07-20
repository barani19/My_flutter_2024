import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_social/helper/helper.dart';
import 'package:minimal_social/utills/button.dart';
import 'package:minimal_social/utills/textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({
    super.key,
    required this.onTap
    });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController userr = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController confpassword = TextEditingController();

   void register()async{
    showDialog(
      context: context,
       builder: (context)=> Center(
        child: CircularProgressIndicator(
        ),
       )
      );
      if(password.text!=confpassword.text){
        // to remove the circle indicator
        Navigator.pop(context);
        // show the alert msg
        displaymsg('Password doesnt match!!', context);
        // clear all the field
        userr.clear();
        email.clear();
        password.clear();
        confpassword.clear();
      }
      else{
        try{
           UserCredential? user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);
           storeuser(user);
              userr.clear();
              email.clear();
              password.clear();
              confpassword.clear();
           Navigator.pop(context);
           // clear all the field

        }on FirebaseAuthException catch(e){
          Navigator.pop(context);
          displaymsg(e.toString(), context);
        }
      }
   }

   Future<void> storeuser(UserCredential? user)async{
    if(user!=null && user.user!=null){
    await FirebaseFirestore.instance.collection('users').doc(user.user!.email).set({
      'username': userr.text,
      'email': user.user!.email,
      'password': password.text
    });
   }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 90,
                  ),
                  SizedBox(height: 10,),
                  Text('M I N I M A L',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  SizedBox(height: 10,),
                   Mytextfield(
                    text: 'User Name',
                     mycontroll: userr,
                    obscuretext: false),
                  SizedBox(height: 10,),
                  Mytextfield(
                    text: 'Email Id',
                     mycontroll: email,
                    obscuretext: false),
                  SizedBox(height: 10,),
                  Mytextfield(
                    text: 'Password',
                     mycontroll: password,
                    obscuretext: true),
                    SizedBox(height: 10,),
                     Mytextfield(
                    text: 'Confirm Password',
                     mycontroll: confpassword,
                    obscuretext: true),
                  SizedBox(height: 15,),
                  Button(text: 'Register', ontap: register),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?',style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),),
                      TextButton(onPressed: widget.onTap, child: Text('Login Here',style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}