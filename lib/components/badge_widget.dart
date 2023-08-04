import 'package:badges/badges.dart' as badges;
import 'package:cafe_app/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/home_controller.dart';
import '../screens/cart/cartscreen.dart';
import 'dimensions.dart';

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
                badgeStyle: badges.BadgeStyle(
                  badgeColor: mainColor
                ),
                badgeContent: Consumer<HomeController>(
                  builder: (context, value,child) { 
                    return Text(value.getCounter().toString(), style:  TextStyle(color: mainColor /*Colors.white*/));
                   },
                ),
                child:  IconButton(
                            icon: Icon( Icons.shopping_cart_outlined, size: Dimensions.iconSize24,), 
                            color: textColor,
                            onPressed: () { 
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const CartScreen()));
                            },
                        ),
              );
  }
}