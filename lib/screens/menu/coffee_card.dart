import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoffeeCard extends StatelessWidget {

  List<String> images = [
    'food/one.jpg',
    'food/two.jpg',
    'food/three.jpg',
    'food/four.jpg',
  ];

  List<String> ingredients = [
    'With Chicken',
    'With Noodles',
    'With Prawns',
    'With Green Veg',
  ];

   List<String> price = [
    '220.0',
    '190.0',
    '250.0',
    '300.0',
  ];

  @override
  Widget build(BuildContext context) {
    return 
    
    Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
       
       
        itemBuilder: (context, index) {
          return Row(
            children: [
            ]
          );
        },
       ),
    );
  }
}