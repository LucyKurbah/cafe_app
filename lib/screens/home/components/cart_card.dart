import 'package:flutter/material.dart';
import 'package:cafe_app/models/Cart.dart';
import 'package:cafe_app/models/Product.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:cafe_app/services/cart_service.dart';
import 'package:cafe_app/services/api_response.dart';
import 'package:cafe_app/api/apiFile.dart';
import 'package:cafe_app/screens/user/login.dart';
import 'package:get/get.dart';

class CartCard extends StatelessWidget {

  CartCard({
    Key? key,
    required this.cart,
    required this.addItem,
    required this.removeItem,
  }) : super(key : key);

  final Cart cart;

  final VoidCallback addItem, removeItem;
  
  @override
  Widget build(BuildContext context) {
   
    return Container(
            height: 150,
            width: double.infinity,
            child: Card(
              color: Colors.grey[900],
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 130,
                        width: 140,
                        child:
                              Image.network(
                                 cart.image,
                                  fit: BoxFit.contain,
                                  scale: 0.4,
                                )
                      ),
                     
                      Container(
                        height: 140,
                        width: 200,
                        child: ListTile(
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cart.item_name, style: TextStyle(color: Colors.white),),
                             
                                Text("₹ ${cart.item_price} ", style: TextStyle(
                                  color: Color(0xff9b96d6),
                                  fontWeight: FontWeight.bold
                                ),),
                                
                                Container(
                                  height: 40,
                                  width: 150,
                                  color: Color(0xff2f2f2),
                                  
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      
                                      GestureDetector(
                                        child: Icon(Icons.delete_rounded, color: Colors.white,),
                                        onTap:removeItem
                                      ),
                                      Text("${cart.quantity}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white
                                        ),
                                      ),
                                      
                                       GestureDetector(
                                        child: Icon(Icons.add, color: Colors.white),
                                        onTap: addItem,
                                      ),
                                      
                                    ],
                                  ),
                                )
                              ],
                            ),
                        ),
                      )
                    ],
                  ),
                 
                ],
              ),
            ),
      );
  }
}