import 'package:flutter/material.dart';
import 'package:spotify_ui/list.dart';

class Listt extends StatelessWidget {

   const Listt({
    super.key,
    required this.bh,
    required this.conth,
    required this.contw,
    required this.ih,
    required this.iw
    });
  final double bh;
   final double conth;
  final  double contw;
   final double ih;
  final  double iw; 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
                height: bh,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recent.length,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Container(
                        height: conth,
                        width: contw,
                        child: Column(
                          children: [
                            Image(image: AssetImage(recent[index]),height: ih,width: iw,),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15,right: 5,top: 5),
                              child: name[index],
                            ),
                          ],
                        ),
                      ),
                    ) ;
                  }
                  ),
              );
  }
}
