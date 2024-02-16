import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/colors.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
     return Column(
      children: [
        Container(
          color: mainColor,
          child: Center(
            child: Image.asset(
                "Assets/lottie/onboarding1.png",
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