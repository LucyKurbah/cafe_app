import 'dart:convert';
import 'package:cafe_app/services/user_service.dart';
import 'package:http/http.dart' as http;
import '../api/apiFile.dart';
import 'api_response.dart';

  
Future<ApiResponse> getFaqs() async{
    ApiResponse apiResponse = ApiResponse();
  
   try {
      String token = await getToken();
      final response = await http.post(Uri.parse(ApiConstants.getFaqsUrl),
                  headers: {
                      'Accept' : 'application/json',
                      'Authorization' : 'Bearer $token'
                  });
      switch(response.statusCode)
      {
        
        case 200:
  
          if(response.body =='305'){
            apiResponse.data = '';
          }
          else if(response.body == '400'){
            
            apiResponse.error = ApiConstants.notLoggedIn;
          }
          else{
            print(response.body);
            apiResponse.data =  jsonDecode(response.body).toList();
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
