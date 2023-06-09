
import 'dart:convert';
import 'package:cafe_app/services/user_service.dart';
import 'package:http/http.dart' as http;
import '../api/apiFile.dart';
import '../models/Product.dart';
import 'api_response.dart';

Future<ApiResponse> getProducts() async{
  // String token = await getToken();
    int userId = await getUserId();print(userId);
  ApiResponse apiResponse = ApiResponse();
  try {
        final response = await http.post(Uri.parse(ApiConstants.itemUrl),
                                headers: {'Accept' : 'application/json',},
                                body:{
                                  'user_id' : userId.toString()
                                });
        switch(response.statusCode)
        {
          case 200:
            apiResponse.data =  jsonDecode(response.body).map((p) => Product.fromJson(p)).toList();
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

