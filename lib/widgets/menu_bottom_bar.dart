import 'package:flutter/material.dart';



class MenuBottomBar extends StatelessWidget {
  const MenuBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 8
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.shopping_cart,color: Color(0xffe57734),size: 27,),
          Icon(Icons.circle_outlined,color: Color(0xffe57734),size: 27,),
        ],
      ),
    );
  }
}