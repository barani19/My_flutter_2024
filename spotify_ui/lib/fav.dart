import 'package:flutter/material.dart';

class Fav extends StatelessWidget {
  const Fav({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
       child: Scaffold(
         appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.green,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(
                child: Text('Playlists',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              Tab(
                child: Text('Artists',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              Tab(
                child: Text('Albums',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              Tab(
                child: Text('Podcasts',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              ),
            ],
          ),
         ),
         body: Padding(
           padding: const EdgeInsets.all(10.0),
           child: TabBarView(
            children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: 1000,
                    child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: Row(
                             children: [
                              Image.asset('assets/images/ar.png',height: 50,width: 50,),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('A.R.Rahman Hits',maxLines: 1,
                                    overflow: TextOverflow.ellipsis
                                    ,style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                    ),),
                                    Text('by you',maxLines: 1,
                                    overflow: TextOverflow.ellipsis,style: TextStyle(
                                      color: const Color.fromARGB(255, 104, 93, 93),
                                      fontWeight: FontWeight.bold
                                    ),),
                                  ],
                                ),
                              )
                             ],
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),   Center(
              child: Container(
                child:Text('Artists',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              ),
            ),
              Center(
                child: Container(
                child:Text('Albums',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                            ),
              ),
              Center(
                child: Container(
                child:Text('Podcasts',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                            ),
              ),
           ]),
         ),
       ));
  }
}