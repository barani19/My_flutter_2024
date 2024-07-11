import 'package:flutter/material.dart';

class CurrencyConvertor extends StatefulWidget {
  const CurrencyConvertor({super.key});

  @override
  State<CurrencyConvertor> createState() => _CurrencyConvertorState();
}

class _CurrencyConvertorState extends State<CurrencyConvertor> {
  TextEditingController control = TextEditingController();
  double result  = 0;
  @override
  void dispose(){
    super.dispose();
    control.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Currency Convertor App',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('INR ${result!=0?result.toStringAsFixed(2):result.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
              ),
              const SizedBox(height: 15,),
              TextField(
                controller: control,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  hintText: 'Enter a usd value',
                  hintStyle: TextStyle(
                   color: Colors.black,
                   fontWeight: FontWeight.bold
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.blue
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.orange
                    )
                  ),
                ),
              ),
               const SizedBox(height: 15,),
              TextButton(onPressed: (){
                result = double.parse(control.text) * 81;
                setState(() {
                  
                });
              },
               child:  Text('Convert'),
               style: TextButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.amberAccent,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 20,
                  )
               ),
               )
            ],
          ),
        ),
      ),
    );
  }
}