import 'package:flutter/material.dart';
import 'package:shoe_app/productcard.dart';
import 'package:shoe_app/productdetpage.dart';
import 'package:shoe_app/products.dart';

class Home extends StatefulWidget {
   Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
    final List<String> cards = [
    'All','Addidas','Nike','Bata'
  ];

  late String select = cards[0];

  // @override
  // void initState() {
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
     final border = OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 255, 1),
                      ),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(30),
                      )
                    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Shoes \n Collection',style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                Expanded(
                  child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    prefixIcon: Icon(Icons.search),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                ))
              ],
            ),
            SizedBox(height: 10,),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cards.length,
                itemBuilder: (context,index){
                  final label = cards[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                         select = label;
                      });
                    },
                    child: Chip(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                      backgroundColor: select==label?Theme.of(context).colorScheme.primary:Color.fromARGB(255, 245, 242, 242),
                      label:  Text(label,style: TextStyle(fontWeight: FontWeight.bold),),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.white
                        )
                      ),
                      ),
                  ),
                );
              }),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: size.width>1080?
              GridView.builder(
                itemCount: Products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                childAspectRatio: 1.95
                ),
                 itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return  Productdet(
                         map: Products[index],
                           );
                        })
                      );
                    },
                    child: Productcard(
                      title: Products[index]['title'] as String,
                       price: Products[index]['price'] as String,
                        img: Products[index]['Imageurl'] as String,
                        bg: index.isEven?
                         const Color.fromRGBO(216, 240, 253, 1):
                          const Color.fromRGBO(245, 247, 249, 1)
                    ),
                  );
                 }
                 )
              :ListView.builder(
                itemCount: Products.length,
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return  Productdet(
                         map: Products[index],
                           );
                        })
                      );
                    },
                    child: Productcard(
                      title: Products[index]['title'] as String,
                       price: Products[index]['price'] as String,
                        img: Products[index]['Imageurl'] as String,
                        bg: index.isEven?
                         const Color.fromRGBO(216, 240, 253, 1):
                          const Color.fromRGBO(245, 247, 249, 1)
                    ),
                  );
              }),
            )
          ],
        ),
      ),
    );
  }
}