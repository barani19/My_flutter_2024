import 'package:flutter/material.dart';
import 'package:minimal_social/pages/loginpage.dart';
import 'package:minimal_social/pages/registerpage.dart';

class loginorout extends StatefulWidget {
  const loginorout({super.key});

  @override
  State<loginorout> createState() => _loginoroutState();
}

class _loginoroutState extends State<loginorout> {
  bool showloginpage = true;

  void togglepage(){
    setState(() {
      showloginpage = !showloginpage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showloginpage){
      return LoginPage(onTap: togglepage,);
    }
    else{
      return RegisterPage(onTap: togglepage,);
    }
  }
}