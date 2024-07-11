import 'package:flutter/material.dart';

class Mycard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const Mycard({
    super.key,
     required this.time,
    required this.icon,
    required this.temp
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                  width: 100,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(time,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Icon(icon,size: 30,),
                          SizedBox(height: 10,),
                          Text(temp,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ),
                );
  }
}