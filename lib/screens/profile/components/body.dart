import 'package:cafe_app/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 115, width : 115,
        child: Stack( 
          fit:StackFit.expand ,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("Assets/Images/profile.png"),
            ),
            Positioned(
              right: -12,
              bottom: 0,
              child: SizedBox(
                height: 46,
                width: 46,
                child: ElevatedButton(
                  
                  onPressed: (){}, 
                  child: SvgPicture.asset("Assets/Images/user.png")),
              ))
          ],))
      ],
    );
  }
}