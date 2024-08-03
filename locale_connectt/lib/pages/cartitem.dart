import 'package:flutter/material.dart';
import 'package:locale_connectt/Auth/cartprovider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Cartitem extends StatefulWidget {

   Cartitem({
    super.key,
    required this.pimage,
     required this.pname,
     required this.price,
     required this.email,
     required this.lat,
     required this.long,
     required this.product
    });
      final String pimage;
  final String pname;
  final String price;
  final String email;
  final double lat;
  final double long;
  final List<dynamic> product;

  @override
  State<Cartitem> createState() => _CartitemState();
}

class _CartitemState extends State<Cartitem> {
      
      bool like = false;
        Future<void> openMap() async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$widget.lat,$widget.long';
    await launchUrlString(googleUrl);
  }
  @override
  Widget build(BuildContext context) {
    double total = 0;
    List<dynamic> shop = [];

    for(var data in widget.product){
      if(data['email'] == widget.email){
        shop.add(data);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Item',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 30),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
      ),
     body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
       child: Padding(
         padding: const EdgeInsets.all(10.0),
         child: Column(
          children: [
            Image.network('${widget.pimage}',height: 350,width: double.infinity,fit: BoxFit.cover,),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                      Text("${widget.pname}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                  SizedBox(height: 5,),
                  Text("Rs: ${widget.price}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                      ]
                    )
                  ),
                ),
                Align(
                  child: Row(
                     children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<Cartprovider>(context,listen: false).addproduct({
                    'pimage': widget.pimage,
                    'pname': widget.pname,
                    'price': widget.price
                   });
                    Provider.of<Cartprovider>(context,listen: false).addmoney(double.parse(widget.price));
                        },
                        child: Icon(Icons.add_circle_outline,color: Colors.amber,size: 30,)),
                     Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: ()=> setState(() {
                        like = !like;
                      }),
                      child: Icon(like ? Icons.favorite : Icons.favorite_border,size: 30,color: Colors.redAccent,)),
                  ),
                GestureDetector(
                  onTap: () => openMap(),
                  child: Icon(Icons.location_on_outlined,size: 30,color: Colors.greenAccent,)),
                     ]
                  )
                ),
              ],
            ),
            SizedBox(height: 10,),
            Text('More products in this shop',overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: shop.length,
                itemBuilder: (context, index) {
                  final String image = shop[index]['iimage'];
                  final String iname = shop[index]['iname'];
                  final String iprice = shop[index]['iprice'];
                  return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 150,
                                 decoration: BoxDecoration(
                              
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white70,
                              border: Border.all(color: Color.fromARGB(255, 232, 244, 249)),
                              boxShadow: [
                                new BoxShadow(
                                  color: const Color.fromARGB(255, 210, 207, 207),
                                  spreadRadius: 1,
                                  blurRadius: 5
                                )
                              ]
                            ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Cartitem(
                                              email: widget.email,
                                              pimage: image,
                                              pname: iname,
                                              lat: widget.lat,
                                              long: widget.long,
                                              price: iprice,
                                              product: widget.product,
                                            ),
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          '$image',
                                          height: 100,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0,top: 5),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              '$iname',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 52, 94)
                                    ),
                                            ),
                                          ),
                                        ),
                                        IconButton(onPressed: (){
                                           Provider.of<Cartprovider>(context,listen: false).addproduct({
                                          'pimage': widget.pimage,
                                          'pname': widget.pname,
                                          'price': widget.price
                                        });
                                                          Provider.of<Cartprovider>(context,listen: false).addmoney(double.parse(widget.price));
                                        }, icon: Icon(Icons.add_circle_outline,size: 30,color: Colors.amber,))
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0,top: 0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Rs.$iprice',
                                          overflow: TextOverflow.ellipsis,
                                         style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color.fromARGB(255, 16, 128, 219)
                                    ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
              },),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                   backgroundColor:  Color.fromARGB(255, 98, 164, 219)
                ),
                onPressed: (){
                   Provider.of<Cartprovider>(context,listen: false).addproduct({
                    'pimage': widget.pimage,
                    'pname': widget.pname,
                    'price': widget.price,
                    'email': widget.email,
                   });
                    Provider.of<Cartprovider>(context,listen: false).addmoney(double.parse(widget.price));
                   
                   
                }, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart,color: Colors.black,),
                  Text("Add to cart",style: TextStyle(color: Color.fromARGB(255, 2, 39, 69),fontWeight: FontWeight.bold,fontSize: 15),),
                ],
              )),
            )
          ],
         ),
       ),
     ),
    );
  }
}