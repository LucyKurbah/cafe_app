import 'dart:math';

import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:cafe_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
            height: 145,
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
                                   child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                                    child: Image.network(
                                      this.product.image,
                                      fit: BoxFit.cover, // You can use 'cover' for aspect ratio preservation
                                    ),
                                  ),
                                ),
                        ),
                        Expanded(
                          child: ListTile(
                              title: Column(
                                children: [
                                   Row(
                                    mainAxisAlignment:(product.flag == 'E' || product.flag == 'C' || product.flag == 'T')? MainAxisAlignment.spaceBetween: MainAxisAlignment.start,
                                    children: [
                                      BigText(" ${product.item_name}",textColor,Dimensions.font20),
                                      if(product.flag == 'E' || product.flag == 'C' || product.flag == 'T')
                                        SmallText("${product.table_date}",greyColor,Dimensions.font15) 

                                     // SmallText("₹ ${product.item_price}  x ${product.quantity}",greyColor,Dimensions.font15),
                                    ],
                                  ),
                                
                                  // if(product.flag == 'E' || product.flag == 'C' || product.flag == 'T')
                                  //       Text( "${convertTimeToAMPM(product.time_from)} | ${convertTimeToAMPM(product.time_to)}", style: TextStyle(color: greyColor,fontSize: 13),),
                                  SizedBox(height: Dimensions.height10,),
                                  if(product.flag == 'E' || product.flag == 'C' || product.flag == 'T')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [                                    
                                       SmallText("${convertTimeToAMPM(product.time_from)} | ${convertTimeToAMPM(product.time_to)}",greyColor,Dimensions.font15)                                   
                                    ],
                                  ),
                                    SizedBox(height: Dimensions.height5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                    //  BigText(" ${product.item_name}",textColor,Dimensions.font20),
                                      SmallText("₹ ${product.item_price}  x ${product.quantity}",greyColor,Dimensions.font15),
                                    ],
                                  ),
                                  // SizedBox(height: Dimensions.height5,),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                  //   children: [
                                  //      SmallText("x ${product.quantity}",greyColor,Dimensions.font15)
                                  //   ],
                                  // ),
                                  //  SizedBox(height: Dimensions.height10,),                                                                                                
                                  SizedBox(height: Dimensions.height20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                       Text("₹ ${product.item_price * product.quantity} ", style:  TextStyle(
                                        color: textColor,
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
String convertTimeToAMPM(String time) {
  final formattedTime = DateFormat('hh:mm a').format(
    DateFormat('HH:mm:ss').parse(time),
  );
  return formattedTime;
}