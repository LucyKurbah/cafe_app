import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/notification_services.dart';

import 'package:flutter/material.dart';


import 'home.dart';

import '../orders/my_orders.dart';
import '../profile/profile.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int index = 0;
  final screens = [
   const Home(),
   const MyOrders(),
   const Profile(),
  ];
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState(){
    super.initState();
    notificationServices.getDeviceToken().then((value){
      print(value);
      print("DEVICE TOKEN");
    });
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