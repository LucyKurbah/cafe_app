import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import '../../models/Orders.dart';

class OrdersCard extends StatelessWidget {


  OrdersCard({
    Key? key,
    required this.product
  }) : super(key: key);
  Order product;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>const  HomeScreen()), (route) => false); },
      child: SizedBox(
              height: 150,
              width: double.infinity,
              child: Card(
                color: greyColor9,
                child: Column(
                  children: [
                    Row(
                      children: [
                        
                        SizedBox(
                          height: 140,
                          width: 200,
                          child: ListTile(
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Order Id : ${product.id}", style:  TextStyle(color: textColor),),
                                  Text("Order Amount: ₹ ${product.item_price} ", style:  TextStyle(
                                    color: lightBlueGrey,
                                    fontWeight: FontWeight.bold
                                  ),),
                                  // Text(product.item_name, style: TextStyle(color: textColor),),
                                  // Text(product.item_name, style: TextStyle(color: textColor),),
                                  
                                ],
                              ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Icon(Icons.chevron_right, color: greyColor8, size: 50,),
                      ],
                    ),
                   
                  ],
                ),
              ),
        ),
    );
  }
}