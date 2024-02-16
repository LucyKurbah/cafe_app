import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/colors.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: mainColor,
          child: Center(
            child: Image.asset(
                "Assets/lottie/onboarding2.png",
                height: 500,
                width: 300,
              ),
          ),
        ),
        SizedBox(height: 1,),
       Text(
        "Get Started",
        style: GoogleFonts.laila(
              fontWeight: FontWeight.w600,
            fontSize: 50,
            color: textColor
            ),  
      ),
  
      SizedBox(height: 1,),
      Text(
        "Let's goooo",
        style: GoogleFonts.laila(
              
            fontSize:20,
            color: textColor
            ),
            
            
      )
      ],
    );
  }
}