import 'package:cafe_app/components/colors.dart';
import 'package:flutter/material.dart';



class MenuBottomBar extends StatelessWidget {
  const MenuBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 65,
      decoration: BoxDecoration(
        color: greyColor8,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),

        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 8
          )
        ]
      ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.shopping_cart,color: iconColors1,size: 27,),
          Icon(Icons.circle_outlined,color: iconColors1,size: 27,),
        ],
      ),
    );
  }
}