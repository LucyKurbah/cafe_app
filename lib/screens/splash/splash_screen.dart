import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/screens/home/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../components/dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 2), (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Loading()));
    });


  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [greyColor,mainColor],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft
          ),

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(Icons.edit,
            // size: 80,
            // color: textColor,),
           Lottie.asset('Assets/lottie/Animation1.json',
        width: 300, repeat: true, animate: true)
            ?? Container(),
             SizedBox( height: Dimensions.height20,),
            Text("BISCI", style: TextStyle(
              fontStyle: FontStyle.italic,
              color: textColor,
              fontSize: 32
            ),),
          ],
        ),
      )
    );
  }
}