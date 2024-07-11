import 'package:flutter/material.dart';
import 'package:spotify_ui/list.dart';
import 'package:spotify_ui/listbuilder.dart';

class HomePage extends StatefulWidget {


    HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recently played',style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
                    Icon(Icons.settings,size: 30,),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Listt(
                bh: 180,
                conth: 120,
                contw: 100,
                ih: 100,
                iw: 100,
              ),
              Text('Made for you',style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
              SizedBox(
                height: 430,
                child: Center(
                  child: GridView.builder(
                    itemCount: Made.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                     itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.only(left:15.0,top: 10.0),
                        child: Container(
                          height: 200,
                          width: 190,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(image: AssetImage(Made[index]),height: 150,width: 150,),
                              Mname[index],
                            ],
                          ),
                        ),
                      ) ;
                     }
                     ),
                ),
              ),
              SizedBox(height: 10,),
              Text('Popular and trending',style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
              SizedBox(height: 20,),
              Listt(
                bh: 290,
                conth: 250,
                contw: 200,
                ih: 200,
                iw: 200,
              ),
              Text('Editor\'s Pick',style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 20,),
              Listt(
                bh: 290,
                conth: 250,
                contw: 200,
                ih: 200,
                iw: 200,
              ),
              Text('Best of artists',style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 20,),
              Listt(
                bh: 290,
                conth: 250,
                contw: 200,
                ih: 200,
                iw: 200,
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}