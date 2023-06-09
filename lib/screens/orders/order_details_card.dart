import 'dart:math';

import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:cafe_app/screens/home/home.dart';
import 'package:cafe_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

import '../../constraints/constants.dart';
import '../../models/Orders.dart';

class OrderDetailsCard extends StatelessWidget {


  OrderDetailsCard({
    Key? key,
    required this.product
  }) : super(key: key);
  Order product;
  
  @override
  Widget build(BuildContext context) {
    return Container(
            height: 120,
            width: double.infinity,
            child: Card(
              color: Colors.grey[900],
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Row(
                      children: [
                        // Container(
                        //   height: 110,
                        //   width: 120,
                        //   child:
                        //         Image.network(
                        //            product.image,
                        //             fit: BoxFit.contain,
                        //             scale: 0.2,
                        //           )
                        // ),
                         InkWell(
                                onTap: () {
                                  
                                },
                                child: 
                                Container(
                                  // margin: const EdgeInsets.only(top: 10),
                                  height: 110,
                                  width: 120,
                                  child:
                                        Image.network(
                                            product.image,
                                            fit: BoxFit.contain,
                                            scale: 0.2,
                                          )
                                      
                                ),
                        ),
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2,
                          child: ListTile(
                              title: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                     // Text(" ${product.item_name}", style: TextStyle(color: Colors.white),),
                                      BigText(" ${product.item_name}",textColor,Dimensions.font20),
                                      BigText("₹ ${product.item_price}",textColor,Dimensions.font20),
                                      //Text("₹ ${product.item_price}", style: TextStyle(color: Colors.white,fontSize: 15)),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                       //Text("x ${product.quantity}", style: TextStyle(color: Colors.white),),
                                       SmallText("x ${product.quantity}",textColor,Dimensions.font17)
                                    ],
                                  ),
                                    SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                       Text("Amount: ₹ ${product.item_price * product.quantity} ", style: TextStyle(
                                        color: Color(0xff9b96d6),
                                        fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                          ),
                        ),
                        // Expanded(child: SizedBox()),
                       

                      ],
                    ),
                  ),
                 
                ],
              ),
            ),
      );
  }
}