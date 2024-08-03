import 'package:flutter/material.dart';

class Cartprovider extends ChangeNotifier{
   List<Map<String,dynamic>> cart  = [];
   List<Map<String,dynamic>> order  = [];
  double total = 0;
  void addproduct(Map<String,dynamic> product){
    cart.add(product);
    notifyListeners();
  }
  void removeproduct(Map<String,dynamic> product){
    cart.remove(product);
    notifyListeners(); 
   }
   void updateorder(List<Map<String,dynamic>> mycart){
    order += mycart;
    notifyListeners(); 
   }
   void removeall(){
     cart = [];
     total = 0;
    notifyListeners(); 
   }
   void addmoney(double price){
    total+=price;
   }
   void removemoney(double price){
    total-=price;
   }
   double get money=>total;
}