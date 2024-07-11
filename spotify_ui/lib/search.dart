import 'package:flutter/material.dart';
import 'package:spotify_ui/list.dart';

class search extends StatelessWidget {
  const search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text('Search',style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 10,),
              Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(Icons.search,size: 40,color: Colors.black,),
                    SizedBox(width: 10,),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text('Search artists,songs and playlists',style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                              ),maxLines: 1,overflow: TextOverflow.ellipsis,),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  height: 800,
                  child: GridView.builder(
                    itemCount: searchh.length-1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.9),
                     itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                         height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: colorr[index],
                            borderRadius: BorderRadius.circular(7), 
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[Text(searchh[index],style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              )),
                              ]
                            ),
                          ),
                        ),
                      );
                     }
                     ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}