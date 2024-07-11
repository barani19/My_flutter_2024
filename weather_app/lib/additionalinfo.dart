import 'package:flutter/material.dart';

class additionalinfo extends StatelessWidget {
  final IconData logo;
  final String climate;
  final String temp;
  const additionalinfo({
    super.key,
    required this.logo,
    required this.climate,
    required this.temp
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(logo,size: 30,),
        Text(climate,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
        Text(temp,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
      ],
    );
  }
}
