import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/notification_services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../api/apiFile.dart';
import '../../models/PopUp.dart';
import '../../services/api_response.dart';
import '../../services/popup_service.dart';
import 'home.dart';

import '../orders/my_orders.dart';
import '../profile/profile.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  int index = 0;
  final screens = [
   const Home(),
   const MyOrders(),
   const Profile(),
  ];

  NotificationServices notificationServices = NotificationServices();
  List<PopUp> _popUps = [];
  int _currentPopUpIndex = 0;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAndShowPopUp();
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didPauseApp() {
    _resetPopUpShownFlag();
  }

  Future<void> _resetPopUpShownFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('popUpShown', false);
  }

  Future<void> _checkAndShowPopUp() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool popUpShown = prefs.getBool('popUpShown') ?? false;
      print("_checkAndShowPopUp");
      print(popUpShown);
      if (!popUpShown) {
        prefs.setBool('popUpShown', true);
        retrievePopUps();
      }
  }

  Future<void> retrievePopUps() async {
    print("Inside Retrieve popups");
    ApiResponse response = await getPopUps();
    if (response.error == null) {
      setState(() {
        _popUps = response.data as List<PopUp>;
        if (_popUps.isNotEmpty) {
          _showNextPopUp();
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }
  //  void _showNextPopUp() {
  //   if (_currentPopUpIndex < _popUps.length) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       showDialog(
  //         builder: (context) => AlertDialog(
  //           content: SizedBox.fromSize(
  //             child: Stack(
  //               children: [
  //                 // Text("${_popUps[_currentPopUpIndex].pop_up_name}"),
  //                 Image.network(
  //                   _popUps[_currentPopUpIndex].image,
  //                   fit: BoxFit.fill,
  //                 ),
  //                 Positioned(
  //                   bottom: 20.0,
  //                   right: 20.0,
  //                   child: ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.pop(context); // Dismiss the current pop-up
  //                       _currentPopUpIndex++;
  //                       _showNextPopUp(); // Show the next pop-up
  //                     },
  //                     child: Text('Ok'),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //                     TextButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       child: Text("${_popUps[_currentPopUpIndex].pop_up_name}"),
  //                     )
  //                   ],
  //         ),
  //         context: context,
  //       );
  //     });
  //   }
  //  }
void _showNextPopUp() {
  if (_currentPopUpIndex < _popUps.length) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        builder: (context) => FutureBuilder(
          future: precacheImage(
            NetworkImage(_popUps[_currentPopUpIndex].image),
            context,
          ),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while the image is loading
              return Center(
                // child: CircularProgressIndicator(),
              );
            } else {
              // Image has been loaded, show the pop-up
              return AlertDialog(
                content: SizedBox.fromSize(
                  child: Stack(
                    children: [
                      Text("${_popUps[_currentPopUpIndex].pop_up_name}"),
                      Image.network(
                        _popUps[_currentPopUpIndex].image,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        bottom: 20.0,
                        right: 20.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Dismiss the current pop-up
                            _currentPopUpIndex++;
                            _showNextPopUp(); // Show the next pop-up
                          },
                          child: Text('Ok'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
        context: context,
      );
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: darkGrey,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),
          )
        ),
        child: NavigationBar(
          height: 60,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected ,
          backgroundColor: darkGrey,
          selectedIndex: index ,
          // animationDuration: Duration(seconds: 1),
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: [
            NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: greyColor,),
                  selectedIcon: Icon(Icons.home_filled, color:greyColor,), 
                  label: 'Home', ),
            NavigationDestination(
                  icon: Icon(Icons.contact_page_outlined, color: greyColor), 
                  selectedIcon: Icon(Icons.contact_page_rounded, color:greyColor,),
                  label: 'Orders'),
            NavigationDestination(
                  icon: Icon(Icons.person_outline, color: greyColor),
                  selectedIcon: Icon(Icons.person, color:greyColor,), 
                  label: 'Profile', ),
          ],
        ),
      )
    );
  }
}