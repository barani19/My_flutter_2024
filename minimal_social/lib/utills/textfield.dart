import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final String text;
  final TextEditingController mycontroll;
  final bool obscuretext;
  const Mytextfield({
    super.key,
    required this.text,
    required this.mycontroll,
    required this.obscuretext,
    });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: mycontroll,
      decoration: InputDecoration(
        hintText: text,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary
          )
        )
      ),
      obscureText: obscuretext,
    );
  }
}