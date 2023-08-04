
import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: transparentColor,
      elevation: 9.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: Dimensions.height50,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0)
          ),
          color: textColor
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: Dimensions.height50,
              width: MediaQuery.of(context).size.width/2 * 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.home, color: iconColors1,),
                    Icon(Icons.person_outline, color: lightBlueGrey,)
                ],
              ),
            ),
            SizedBox(
              height: Dimensions.height50,
              width: MediaQuery.of(context).size.width/2 * 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.search, color: iconColors1,),
                    Icon(Icons.shopping_basket, color: lightBlueGrey,)
                ],
              ),
            )
        ]),
      ),


    );
  }
}