import 'dart:math';

import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:cafe_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import '../../models/Orders.dart';

class OrderDetailsCard extends StatelessWidget {


  OrderDetailsCard({
    Key? key,
    required this.product
  }) : super(key: key);
  Order product;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
            height: 120,
            width: double.infinity,
            child: Card(
              color: greyColor9,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Row(
                      children: [
                        
                         InkWell(
                                onTap: () {
                                  
                                },
                                child: 
                                SizedBox(
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
                        SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2,
                          child: ListTile(
                              title: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      BigText(" ${product.item_name}",textColor,Dimensions.font20),
                                      BigText("₹ ${product.item_price}",textColor,Dimensions.font20),
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.height10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                       SmallText("x ${product.quantity}",textColor,Dimensions.font17)
                                    ],
                                  ),
                                    SizedBox(height: Dimensions.height20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                       Text("Amount: ₹ ${product.item_price * product.quantity} ", style:  TextStyle(
                                        color: lightBlueGrey,
                                        fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                 
                ],
              ),
            ),
      );
  }
}