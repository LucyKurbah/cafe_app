import 'dart:convert';

import 'package:cafe_app/models/Orders.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:http/http.dart' as http;
import '../api/apiFile.dart';
import 'api_response.dart'; // replace with the name of your order model
  
Future<ApiResponse> getOrders() async{
  ApiResponse apiResponse = ApiResponse();

 try {
    String token = await getToken();
    int userId = await getUserId();
    final response = await http.post(Uri.parse(ApiConstants.getOrdersUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
                body:{
                       'user_id': userId.toString(),
                    },   
               );
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
          apiResponse.data =  jsonDecode(response.body).toList();
          print("Order List");
          print(apiResponse.data);
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

Future<ApiResponse> getOrdersDetails(order_id) async{
  ApiResponse apiResponse = ApiResponse();

 try {
    String token = await getToken();
    int userId = await getUserId();

 
    final response = await http.post(Uri.parse(ApiConstants.getOrdersDetailsUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
                body:{
                       'user_id': userId.toString(),
                       'order_id' : order_id.toString(),
                    },   
               );
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
          apiResponse.data =  jsonDecode(response.body).map((p) => Order.fromJson(p)).toList();

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
