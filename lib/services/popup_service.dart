
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/apiFile.dart';
import '../models/PopUp.dart';
import 'api_response.dart';

Future<ApiResponse> getPopUps() async{
  
  // int userId = await getUserId();print(userId);
  ApiResponse apiResponse = ApiResponse();
  try {
        final response = await http.post(Uri.parse(ApiConstants.getPopUpsUrl),
                                headers: {'Accept' : 'application/json',},
                                body:{
                                  // 'user_id' : userId.toString()
                                });
        print("POP UP resposnse code");
        print(response.statusCode);
        switch(response.statusCode)
        {
          case 200:
            // 
            //apiResponse.data =  jsonDecode(response.body).map((p) => PopUp.fromJson(p));
            var jsonData = jsonDecode(response.body);
            if (jsonData is List) {
              apiResponse.data = jsonData.map((p) => PopUp.fromJson(p)).toList();
            } else {
              apiResponse.error = "Unexpected data format.";
            }
            print(response.body);
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

