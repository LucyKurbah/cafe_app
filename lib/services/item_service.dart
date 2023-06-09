import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/apiFile.dart';
import '../models/AddOn.dart';
import 'api_response.dart';

Future<ApiResponse> getItems() async{
  
  ApiResponse apiResponse = ApiResponse();
  try {
        final response = await http.post(Uri.parse(ApiConstants.getAddOnUrl),headers: {'Accept' : 'application/json',});
        
        switch(response.statusCode)
        {
          case 200:

            apiResponse.data =  jsonDecode(response.body).map((p) => AddOn.fromJson(p)).toList();
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
