import 'package:cafe_app/components/colors.dart';
import 'package:flutter/material.dart';

class FavBtn extends StatelessWidget {
  const FavBtn({
    Key? key,
    this.radius = 12,
  }) : super(key: key);
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: redColor),
        child: Text("Add",style: TextStyle(color: textColor, fontSize: 17),));
  }
}
