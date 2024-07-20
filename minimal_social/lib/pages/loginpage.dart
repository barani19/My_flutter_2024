import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_social/helper/helper.dart';
import 'package:minimal_social/utills/button.dart';
import 'package:minimal_social/utills/textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key,required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  void login()async{
    showDialog(context: context, builder: (context)=>Center(child: CircularProgressIndicator(),));
    
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
      if(context.mounted) Navigator.pop(context);
      email.clear();
      password.clear();
    }on FirebaseAuthException catch(e){
      Navigator.pop(context);
      displaymsg(e.code, context);
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
                    text: 'Email Id',
                     mycontroll: email,
                    obscuretext: false),
                  SizedBox(height: 10,),
                  SizedBox(height: 10,),
                  Mytextfield(
                    text: 'Password',
                     mycontroll: password,
                    obscuretext: true),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: (){}, child: Text('Forget Password!!',style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),)),
                  ),
                  SizedBox(height: 10,),
                  Button(text: 'Login', ontap: login),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?',style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),),
                      TextButton(onPressed: widget.onTap, child: Text('Register Here',style: TextStyle(
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