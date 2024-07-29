import 'package:flutter/material.dart';
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
    List<dynamic> shop = [];

    for(var data in widget.product){
      if(data['email'] == widget.email){
        shop.add(data);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Item'),
        centerTitle: true,
      ),
     body: Padding(
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
          Text('More products in this shop',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
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
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 234, 228, 228),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                    child: Image.network(
                                      '$image',
                                      height: 110,
                                      width: 110,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
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
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Rs.$iprice',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
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
                 backgroundColor: Colors.amberAccent
              ),
              onPressed: (){
                print(shop);
              }, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart,color: Colors.black,),
                Text("Add to cart",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
              ],
            )),
          )
        ],
       ),
     ),
    );
  }
}