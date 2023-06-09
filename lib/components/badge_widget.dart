import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/home_controller.dart';
import '../screens/cart/cartscreen.dart';

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Colors.black//Color(0xffe57734)
                ),
                badgeContent: Consumer<HomeController>(
                  builder: (context, value,child) { 
                    return Text(value.getCounter().toString(), style: TextStyle(color: Colors.black /*Colors.white*/));
                   },
                ),
                child:  IconButton(
                            icon: Icon(Icons.shopping_bag_outlined, size: 30,), 
                            color: Colors.white,
                            onPressed: () { 
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => CartScreen()));
                            },
                        ),
              );
  }
}