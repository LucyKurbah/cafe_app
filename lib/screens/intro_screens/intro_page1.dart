import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: Center(
        child: Image.asset(
            "Assets/lottie/laptop.gif",
            height: 125.0,
            width: 125.0,
          ),
      ),
    );
  }
}