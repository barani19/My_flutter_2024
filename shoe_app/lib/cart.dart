import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_app/cartprovider.dart';

class cart extends StatelessWidget {
  const cart({super.key});

  @override
  Widget build(BuildContext context) {
    final mycart = Provider.of<Cartprovider>(context).cart;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart',style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),), 
      ),
      body: ListView.builder(
        itemCount: mycart.length,
        itemBuilder: (context,index){
          final item = mycart[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(mycart[index]['Imageurl'] as String),
            ),
            trailing: IconButton(onPressed: (){
              showDialog(
                 barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Delete item'),
                content: Text('Are you sure want to remove product from cart?'),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text('No',style: TextStyle(color: Colors.blue),)),
                  TextButton(onPressed: (){
                    Provider.of<Cartprovider>(context,listen: false).removeproduct(item);
                     Navigator.of(context).pop();
                  }, child: Text('Yes',style: TextStyle(color: Colors.red),))
                ],
                  );
                },
              );
            },
             icon: Icon(Icons.delete,color: Colors.red,size: 30,)
             ),
            title: Text(mycart[index]['title'] as String),
            subtitle: Text(mycart[index]['price'] as String),
          );
        } 
        ),
    );
  }
}