import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/dimensions.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: mainColor,
          child: Center(
            child: Image.asset(
                "Assets/lottie/onboarding0.png",
                height: 500,
                width: 300,
              ),
          ),
        ),
        SizedBox(height: 1,),
       Text(
        "Welcome",
        style: GoogleFonts.laila(
              fontWeight: FontWeight.w600,
            fontSize: 50,
            color: textColor
            ),  
      ),
  
      SizedBox(height: 1,),
      Text(
        "to BISCI",
        style: GoogleFonts.laila(
              
            fontSize:20,
            color: textColor
            ),
            
            
      )
      ],
    );
  }
}