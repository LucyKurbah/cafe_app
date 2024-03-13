import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/screens/intro_screens/intro_page1.dart';
import 'package:cafe_app/screens/intro_screens/intro_page2.dart';
import 'package:cafe_app/screens/intro_screens/intro_page3.dart';
import 'package:cafe_app/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: mainColor,
        body: Stack(
          children: [
            PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() => isLastPage = index == 2);
                },
                children: [
                  IntroPage1(),
                  IntroPage2(),
                  IntroPage3(),
                ],
          ),
          Container(
            alignment: Alignment(0,0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                      onPressed: () => controller.jumpToPage(2),
                      
                      child: const Text('SKIP',style: TextStyle(fontSize: 20)), ),
                SmoothPageIndicator(
                            controller: controller,
                            count: 3,
                            effect: WormEffect(
                                spacing: 16,
                                dotColor: greyColor,
                                dotWidth: 10,
                                dotHeight: 10,
                                activeDotColor: iconColors1,
                                
                                ),
                            onDotClicked: (index) => controller.animateToPage(index,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut),
                          ),
                isLastPage?
                TextButton(
                       onPressed: () async {
                        final pref = await SharedPreferences.getInstance();
                        pref.setBool('showHome', true);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const SplashScreen()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          // color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: const Text('DONE',
                                    style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey
                                    )),
                      )
                ):
                TextButton(
                      onPressed: () => controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                      child: const Text('NEXT',style: TextStyle(fontSize: 20))
                ),
              ],
            ),
          ),
          ]
        ),
    );
    // return Scaffold(
    //   body: Container(
    //     padding: const EdgeInsets.only(bottom: 80),
    //     child: PageView(
    //       controller: controller,
    //       onPageChanged: (index) {
    //         setState(() => isLastPage = index == 2);
    //       },
    //       children: [
    //         Container(
    //           color: Colors.black,
    //           child: const Center(
    //             child: Text("Page 2"),
    //           ),
    //         ), 
    //         Container(
    //           color: Colors.black,
    //           child: const Center(
    //             child: Text("Page 2"),
    //           ),
    //         ), 
    //         Container(
    //           color: Colors.blue,
    //           child: const Center(
    //             child: Text("Page 3"),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    //   bottomSheet: isLastPage
    //       ? TextButton(
    //           style: TextButton.styleFrom(
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(20)),
    //               primary: iconColors1,
    //               backgroundColor: textColor,
    //               minimumSize: const Size.fromHeight(80)),
    //           onPressed: () async {
    //             final pref = await SharedPreferences.getInstance();
    //             pref.setBool('showHome', true);
    //             Navigator.of(context).pushReplacement(MaterialPageRoute(
    //                 builder: (context) => const SplashScreen()));
    //           },
    //           child: const Text(
    //             "Get Started",
    //             style: TextStyle(fontSize: 24),
    //           ))
    //       : Container(
    //           padding: const EdgeInsets.symmetric(horizontal: 10),
    //           height: 80,
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               TextButton(
    //                   onPressed: () => controller.jumpToPage(2),
    //                   child: const Text('SKIP')),
    //               Center(
    //                 child: SmoothPageIndicator(
    //                   controller: controller,
    //                   count: 3,
    //                   effect: WormEffect(
    //                       spacing: 16,
    //                       dotColor: Colors.black26,
    //                       activeDotColor: iconColors1),
    //                   onDotClicked: (index) => controller.animateToPage(index,
    //                       duration: const Duration(milliseconds: 500),
    //                       curve: Curves.easeInOut),
    //                 ),
    //               ),
    //               TextButton(
    //                   onPressed: () => controller.nextPage(
    //                       duration: const Duration(milliseconds: 500),
    //                       curve: Curves.easeInOut),
    //                   child: const Text('NEXT')),
    //             ],
    //           ),
    //         ),
    // );
   
  }

}
