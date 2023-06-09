
import 'dart:convert';

import 'package:cafe_app/services/table_service.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api/apiFile.dart';
import '../models/Order.dart';
import '../models/EntireFloor.dart';
import '../screens/entire_floor/entire_floor_screen.dart';
import 'api_response.dart';



Future<ApiResponse> getEntireFloor() async{
  
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
  
    final response = await http.post(Uri.parse(ApiConstants.getEntireFloorDetailsUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
               );
    print(response.statusCode);
    switch(response.statusCode)
    {
      case 200:
        apiResponse.data =  jsonDecode(response.body).map((p) => EntireFloor.fromJson(p)).toList();
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


Future<ApiResponse> checkFloorDetails(floor_id,date) async{
  
  ApiResponse apiResponse = ApiResponse();
  try {
   
    String token = await getToken();
    int userId = await getUserId();
    String formattedDate=convertDateToPostgres(date);

    final response = await http.post(Uri.parse(ApiConstants.checkFloorDetailsUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
                body: {
                      'floor_id' : floor_id.toString(),
                      'floor_date' : formattedDate.toString()
                    },
               );
    print("Entire floor details");
    print(response.statusCode);
    switch(response.statusCode)
    {
      case 200:
        apiResponse.data =  jsonDecode(response.body);
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
