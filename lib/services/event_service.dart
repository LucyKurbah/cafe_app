import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/apiFile.dart';
import '../models/Event.dart';
import 'api_response.dart';

Future<ApiResponse> getEvents() async{
  
  ApiResponse apiResponse = ApiResponse();
  try {
        print(ApiConstants.getEventsUrl);
        final response = await http.post(Uri.parse(ApiConstants.getEventsUrl),headers: {'Accept' : 'application/json',});
        print("_____________________________________________)INSIDE===========================================))");
        switch(response.statusCode)
        {
          case 200:
          print("Response Body");
            print(response.body);
            apiResponse.data =  jsonDecode(response.body).map((p) => Event.fromJson(p)).toList();
           
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
