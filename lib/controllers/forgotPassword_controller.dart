import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cafe_app/services/api_response.dart';
import '../screens/user/login.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'package:cafe_app/widgets/custom_widgets.dart';
import '../screens/home/home.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'package:cafe_app/widgets/custom_widgets.dart';
import '../screens/home/home.dart';


class ForgotPasswordController extends GetxController{

   TextEditingController emailController = TextEditingController();
  
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();

  void forgotUserPassword() async{
    String msg ='';
    ApiResponse response = await forgotPassword(emailController.text);
    if(response.error == null){
      print(response.data);
      if(response.data== 200.toString())
      {
          msg = 'Password Reset link sent to email';
      }
      else if(response.data ==300.toString())
      {
        msg = 'Email does not exist';
      }
      
      showSnackBar(title: msg, message:'');
    }
    else{
      // // setState(() {
      //   loading = false;
      // // });
     showSnackBar(title: 'Error', message: '${response.error}');
    }
  }
}