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
     padding: EdgeInsets.only(top:5,bottom: 5,left: 10,right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xffE57734)
                ),
      child: 
      // const Icon(Icons.add),
      Text("Add", style: TextStyle(color: Colors.white, fontSize: 12),)
    );
  }
}
