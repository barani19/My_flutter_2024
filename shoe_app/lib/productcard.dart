import 'package:flutter/material.dart';

class Productcard extends StatelessWidget {
  final String title;
  final String price;
  final String img;
  final Color bg;
  const Productcard({
    super.key,
    required this.title,
    required this.price,
    required this.img,
    required this.bg,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: Theme.of(context).textTheme.bodyLarge,),
          Text('\$$price'),
          Center(child: Image.asset(img,height: 175,)),
        ],
      ),
    );
  }
}