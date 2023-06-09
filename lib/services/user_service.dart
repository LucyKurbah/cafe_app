
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cafe_app/services/api_response.dart';
import 'package:cafe_app/api/apiFile.dart';
import 'package:cafe_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../screens/home/home.dart';


Future<ApiResponse> login(String email, String password,String deviceTokenId) async {
  print(email);
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
            Uri.parse(ApiConstants.loginUrl),
            headers: {'Accept': 'application/json',
                      'Content-type': 'application/json'
                      },
            body: jsonEncode({"email": email, "password": password, "device_token" : deviceTokenId}),
            )
            .timeout(const Duration(seconds: 20), onTimeout: () {
              throw TimeoutException("Connection Time Out. Try Again!");
            },);
    print(response.statusCode);
    switch(response.statusCode)
    {
      case 200:
       
        apiResponse.data =  UserModel.fromJson(jsonDecode(response.body));
        
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
         apiResponse.error = response.statusCode.toString();//ApiConstants.somethingWentWrong;
        break;
    }
  } catch (e) {
     apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> register(String name, String email, String password, String deviceTokenId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(ApiConstants.registerUrl),
      headers: {'Accept':'application/json'},
      body:{
        'name': name, 
        'email': email, 
        'password' : password,
        'password_confirmation' : password,
        'device_token' : deviceTokenId}
    );
      
    switch(response.statusCode)
    {
      case 200:
        apiResponse.data =  UserModel.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
         apiResponse.error = ApiConstants.somethingWentWrong;
        break;
    }
  } catch (e) {
     apiResponse.error = ApiConstants.serverError;
  }

  return apiResponse;
}

Future<ApiResponse> forgotPassword(String email) async {
  ApiResponse apiResponse = ApiResponse();
  print("object");
  try {
    final response = await http.post(
      Uri.parse(ApiConstants.forgotPasswordUrl),
      headers: {'Accept':'application/json'},
      body:{
        'email': email, 
        }
    );
      print(response.statusCode);
    switch(response.statusCode)
    {
      case 200:
        apiResponse.data = response.body;
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
       case 300:
        apiResponse.error = "Email does not exist";
        break;
      default:
         apiResponse.error = ApiConstants.somethingWentWrong;
        break;
    }
  } catch (e) {
     apiResponse.error = ApiConstants.serverError;
  }

  return apiResponse;
}

Future<ApiResponse> getUserDetails() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(ApiConstants.userUrl),
      headers: {
        'Accept':'application/json',
        'Authorization' : 'Bearer $token'
        });

    switch(response.statusCode)
    {
      case 200:   
        apiResponse.data =  UserModel.fromJson(jsonDecode(response.body));
      
        break;
      case 401:
        apiResponse.error = ApiConstants.unauthorized;
        break;
      default:
         apiResponse.error = ApiConstants.somethingWentWrong;
        break;
    }
  } catch (e) {
     apiResponse.error = ApiConstants.serverError;
  }

  return apiResponse;
}

Future<String> getToken() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';

}

Future<int> getUserId() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

void logoutUser() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
   pref.remove('userId');
   pref.remove('token');
  //  Get.to(Home());
}

String? getStringImage(File? file){
  if(file == null) return null;
  return base64Encode(file.readAsBytesSync());
}