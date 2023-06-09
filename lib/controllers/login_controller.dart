import 'package:cafe_app/screens/user/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cafe_app/services/api_response.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'package:cafe_app/widgets/custom_widgets.dart';
import '../screens/home/home.dart';
import 'google_signin_api.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController{
  TextEditingController  txtEmail = TextEditingController();
  TextEditingController  txtPassword = TextEditingController();
  String? deviceTokenId;                     
  
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();

  void loginUser() async{
    
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    deviceTokenId = await messaging.getToken();
      print("DEVICE TOKEN ID IS");
      print(deviceTokenId);
    
    ApiResponse response = await login(txtEmail.text, txtPassword.text, deviceTokenId!);
    if(response.error == null){
      _saveAndRedirectToHome(response.data as UserModel);
    }
    else{
      // setState(() {
      //   loading = !loading;
      // });
     showSnackBar(title: 'Error', message: '${response.error}');
    }
  }

  Future<void> saveDeviceTokenIdToSharedPreferences() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    deviceTokenId = await messaging.getToken();
   
   
  }

  void signIn() async{

    GoogleSignIn _googleSignIn = GoogleSignIn();
    try{
        var result = await _googleSignIn.signIn();
        print(result);
        // await GoogleSignInApi.login();
    }catch(error)
    {
      print(error);
    }

  }

  void logoutUser() async{
        logoutUser();
        showSnackBar(title: 'Success', message: 'Logged Out');
        _saveAndRedirectToLogin();
  }

  void _saveAndRedirectToHome(UserModel user) async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token );
    await pref.setInt('userId', user.id );
    txtEmail.clear();
    txtPassword.clear();
    Get.off(Home());
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }

  void _saveAndRedirectToLogin() async
  {
    Get.off(Login());
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }

}