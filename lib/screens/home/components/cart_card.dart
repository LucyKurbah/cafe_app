import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/models/Cart.dart';
import 'package:intl/intl.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cart,
    required this.addItem,
    required this.removeItem,
  }) : super(key: key);

  final Cart cart;

  final VoidCallback addItem, removeItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
                    color: greyColor9,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(17),
                    ),
                  ),
      child: Card(
        color: greyColor9,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                    height: 140,
                    width: 120,
                    child: Image.network(
                      cart.image,
                      fit: BoxFit.contain,
                      scale: 0.4,
                    )),
                Expanded(
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cart.item_name,
                          style: TextStyle(color: textColor),
                        ),
                        SizedBox(height: Dimensions.height20),
                        if(cart.flag == 'E' || cart.flag == 'C' || cart.flag == 'T')
                          Text("${cart.date}", style: TextStyle(color: greyColor, fontSize: 13),),
                        SizedBox(height: Dimensions.height5),
                        if(cart.flag == 'E' || cart.flag == 'C' || cart.flag == 'T')
                          Text( "${convertTimeToAMPM(cart.timeFrom!)} | ${convertTimeToAMPM(cart.timeTo!)}", style: TextStyle(color: greyColor,fontSize: 13),),
                        SizedBox(height: Dimensions.height5),
                        Text(
                          "₹ ${cart.item_price} ",
                          style:  TextStyle(
                              color: lightBlueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                        
                          Container(
                            
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  GestureDetector(
                                    onTap: removeItem,
                                    child: Icon(
                                      Icons.delete_rounded,
                                      color: textColor,
                                  )),
                                  SizedBox(width: Dimensions.height10),
                                  if (cart.flag != 'E' && cart.flag != 'C' && cart.flag != 'T')
                                    
                                    Text(
                                      "${cart.count}",
                                      style:  TextStyle(
                                          fontSize: 16, color: textColor),
                                    ),
                                  
                                    SizedBox(width: Dimensions.height10),
                                    if (cart.flag != 'E' && cart.flag != 'C' && cart.flag != 'T')
                                    GestureDetector(
                                      onTap: addItem,
                                      child: Icon(Icons.add, color: textColor),
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

  String convertTimeToAMPM(String time) {
  final formattedTime = DateFormat('hh:mm a').format(
    DateFormat('HH:mm:ss').parse(time),
  );
  return formattedTime;
}
}
