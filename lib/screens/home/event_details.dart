import 'package:cafe_app/components/app_column.dart';
import 'package:cafe_app/components/app_icon.dart';
import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../components/dimensions.dart';
import '../../widgets/custom_widgets.dart';




class EventDetails extends StatelessWidget {
  const EventDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: mainColor,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: Dimensions.eventDetailsImgSize,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                    image: AssetImage("Assets/Images/cafe3.jpg")
                ) 
              ),
            )
          ),
          Positioned(
            top: Dimensions.height45,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppIcon(icon: Icons.arrow_back_ios),
                AppIcon(icon: Icons.shopping_cart_outlined)
              ],
            )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: Dimensions.eventDetailsImgSize-20,
            child: Container(
                padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, top: Dimensions.height20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radius20), topRight: Radius.circular(Dimensions.radius20) ),
                  color: mainColor
                ),
                child: AppColumn()
            )),
        ],
      ),
    );
  }
}