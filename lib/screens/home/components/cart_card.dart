import 'package:cafe_app/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/models/Cart.dart';

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
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Card(
        color: greyColor9,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                    height: 130,
                    width: 140,
                    child: Image.network(
                      cart.image,
                      fit: BoxFit.contain,
                      scale: 0.4,
                    )),
                SizedBox(
                  height: 140,
                  width: 200,
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cart.item_name,
                          style: TextStyle(color: textColor),
                        ),
                        if(cart.flag == 'E' || cart.flag == 'C' || cart.flag == 'T')
                          Text("${cart.date}", style: TextStyle(color: greyColor),),
                        if(cart.flag == 'E' || cart.flag == 'C' || cart.flag == 'T')
                          Text("${cart.timeFrom} | ${cart.timeTo}", style: TextStyle(color: greyColor),),
                        Text(
                          "₹ ${cart.item_price} ",
                          style:  TextStyle(
                              color: lightBlueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                        
                          Container(
                            height: 40,
                            width: 150,
                            color: const Color(0x0ff2f2f2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: removeItem,
                                    child: Icon(
                                      Icons.delete_rounded,
                                      color: textColor,
                                    )),
                                if (cart.flag != 'E' && cart.flag != 'C' && cart.flag != 'T')
                                  Text(
                                    "${cart.count}",
                                    style:  TextStyle(
                                        fontSize: 16, color: textColor),
                                  ),
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
}
