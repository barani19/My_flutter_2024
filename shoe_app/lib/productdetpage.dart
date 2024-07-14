import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_app/cartprovider.dart';

class Productdet extends StatefulWidget {
  const Productdet({
    super.key,
    required this.map
    
    });

  final Map<String,Object> map;

  @override
  State<Productdet> createState() => _ProductdetState();
}

class _ProductdetState extends State<Productdet> {
  late int select = (widget.map['Sizes'] as List<int>)[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(widget.map['title'] as String,style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold
                  ),),
          Spacer(),
          Image.asset(widget.map['Imageurl'] as String,height: 250,),
          Spacer(),
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 245, 242, 242),
            ),
            child: Column(
              children: [
                Text('\$${widget.map['price']}',style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                )),
                SizedBox(height: 10,),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (widget.map['Sizes'] as List<int>).length,
                    itemBuilder: (context,index){
                      final size = (widget.map['Sizes']as List<int>)[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              select = size;
                            });
                          },
                          child: Chip(
                            backgroundColor: size == select?
                            Theme.of(context).colorScheme.primary:
                            const Color.fromARGB(255, 220, 218, 218),
                            label: Text(size.toString(),style: Theme.of(context).textTheme.bodyMedium,),
                            ),
                        ),
                      );
                  }),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: (){
                    Provider.of<Cartprovider>(context,listen: false).addproduct({
                      'id': widget.map['id'],
                      'title': widget.map['title'],
                      'price': widget.map['price'],
                      'Imageurl': widget.map['Imageurl'],
                      'Company': widget.map['Company'],
                      'Sizes': select,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('Product added to the cart',))
                        );
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.black,
                      fixedSize: Size(180,50),
                    ),
                   child: Text('Add to cart',style: TextStyle(
                     fontSize: 20,
                     fontWeight: FontWeight.bold
                   ),) 
                   ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}