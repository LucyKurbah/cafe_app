import 'dart:convert';
import 'dart:io';
import 'package:cafe_app/models/Orders.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:http/http.dart' as http;
import '../api/apiFile.dart';
import '../models/ProfileModel.dart';
import '../screens/profile/profile.dart';
import 'api_response.dart';

Future<ApiResponse> getProfile() async{
  ApiResponse apiResponse = ApiResponse();
  String token = await getToken();
  int userId = await getUserId();
  try {
    final response = await http.post(Uri.parse(ApiConstants.getProfileUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
                body:{
                       'user_id': userId.toString(),
                    },   
               );
    print(response.statusCode);
    switch(response.statusCode)
    {
      case 200:
        if(response.body == '305'){
          apiResponse.data = '';
        }
        else if(response.body == 'X'){
  
          apiResponse.error = ApiConstants.notLoggedIn;
        }
        else if(response.body == '500'){
  
          apiResponse.error = ApiConstants.notLoggedIn;
        }
        else{
          print("here");
          print(response.body.runtimeType);
            apiResponse.data =  jsonDecode(response.body).map((p) => ProfileModel.fromJson(p)).toList();
        } 
        break;
      case 401:
        apiResponse.error = ApiConstants.unauthorized;
        break;
      case 500:
        apiResponse.error = ApiConstants.notLoggedIn;
        break;
      default:
         apiResponse.error = response.statusCode.toString();
        break;
    }
  } catch (e) {
     apiResponse.error =e.toString();
  }
  return apiResponse;
}

Future<ApiResponse> saveProfileDetailsApiCall(filePath) async{
  ApiResponse apiResponse = ApiResponse();
  String token = await getToken();
  int userId = await getUserId();
  try {
    //var response = await http.MultipartRequest('POST', Uri.parse(ApiConstants.saveProfileUrl));
    final response = await http.post(Uri.parse(ApiConstants.saveProfileUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
                body:{
                       'user_id': userId.toString(),
                    },   
               );
    
  //  var request = http.MultipartRequest('POST', Uri.parse('http://example.com/upload'));
  // var file = File(filePath);
  // var stream = http.ByteStream(file.openRead());
  // stream.cast();
  // var length = await file.length();

  // request.files.add(http.MultipartFile(
  //     'file', stream, length,
  //     filename: basename(file.path)));

  // var Apiresponse = await request.send();


    switch(response.statusCode)
    {
      case 200:
        if(response.body == '305'){
          apiResponse.data = '';
        }
        else if(response.body == 'X'){
  
          apiResponse.error = ApiConstants.notLoggedIn;
        }
        else if(response.body == '500'){
  
          apiResponse.error = ApiConstants.notLoggedIn;
        }
        else{
          print("here");
          print(response.body.runtimeType);
            apiResponse.data =  jsonDecode(response.body).map((p) => ProfileModel.fromJson(p)).toList();
        } 
        break;
      case 401:
        apiResponse.error = ApiConstants.unauthorized;
        break;
      default:
         apiResponse.error = response.statusCode.toString();
        break;
    }
  } catch (e) {
     apiResponse.error =e.toString();
  }
  return apiResponse;
}