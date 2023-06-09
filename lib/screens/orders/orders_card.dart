import 'package:cafe_app/screens/home/home.dart';
import 'package:flutter/material.dart';

import '../../constraints/constants.dart';
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
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (route) => false); },
      child: Container(
              height: 150,
              width: double.infinity,
              child: Card(
                color: Colors.grey[900],
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Container(
                        //   height: 130,
                        //   width: 140,
                        //   child:
                        //         Image.network(
                        //            product.image,
                        //             fit: BoxFit.contain,
                        //             scale: 0.4,
                        //           )
                        // ),
                        Container(
                          height: 140,
                          width: 200,
                          child: ListTile(
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Order Id : ${product.id}", style: TextStyle(color: Colors.white),),
                                  Text("Order Amount: ₹ ${product.item_price} ", style: TextStyle(
                                    color: Color(0xff9b96d6),
                                    fontWeight: FontWeight.bold
                                  ),),
                                  // Text(product.item_name, style: TextStyle(color: Colors.white),),
                                  // Text(product.item_name, style: TextStyle(color: Colors.white),),
                                  
                                ],
                              ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Icon(Icons.chevron_right, color: Colors.grey[800], size: 50,),
                      ],
                    ),
                   
                  ],
                ),
              ),
        ),
    );
  }
}