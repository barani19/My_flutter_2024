import 'package:flutter/material.dart';

class Button extends StatelessWidget {
   final void Function()? ontap;
   final String text;
  const Button({
    super.key,
    required this.text,
    required this.ontap
    });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity,50),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary
      ),
      onPressed: ontap,
       child: Text(text,style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold
       ),),
       );
  }
}