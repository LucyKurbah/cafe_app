import 'package:cafe_app/models/Conference.dart';
import 'package:cafe_app/models/Orders.dart';
import 'package:cafe_app/screens/add_on/addOn_page.dart';
import 'package:cafe_app/screens/cart/cartscreen.dart';
import 'package:cafe_app/screens/conference/conference_screen.dart';
import 'package:cafe_app/screens/home/event_details.dart';
import 'package:cafe_app/screens/user/login.dart';
import 'package:cafe_app/screens/menu/menu.dart';
import 'package:cafe_app/screens/orders/my_orders.dart';
import 'package:cafe_app/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import 'home.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

void _loadUserInfo() async {
  String token = await getToken();
  int userId = await getUserId();
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  // if(userId == '' || userId == null)
  // {
  //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  //   // print('Hello world');
  // }
  // else{
  //   ApiResponse response = await getUserDetails();
  //   print(response.data);
   
  //   if(response.error == null)
  //   {
  //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>      Home()), (route) => false);
  //   }
  //   else if(response.error == ApiConstants.unauthorized)
  //   {
  //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>      Login()), (route) => false);
  //   }
  //   else
  //   {
  //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text('$response.error')
  //     ));
  //     // print(token);
  //   }
  // }
}

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
        _loadUserInfo();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}