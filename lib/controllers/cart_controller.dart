


//Not USED . Instear CARD_SERVICE.DART is used

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../api/apiFile.dart';
import '../models/Product.dart';
import '../models/Cart.dart';
import '../services/api_response.dart';
import '../services/user_service.dart';

class CartController extends GetxController{

  CartController()
  {
    getCart();
  }

Future<ApiResponse> getCart() async{
  ApiResponse apiResponse = ApiResponse();
 try {
    String token = await getToken();
    int userId = await getUserId();

    final response = await http.post(Uri.parse(ApiConstants.cartUrl),
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
        // getTotal();
       
        apiResponse.data =  jsonDecode(response.body).map((p) => Cart.fromJson(p)).toList();
       
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


Future<ApiResponse> addToCart(Product product) async{
  ApiResponse apiResponse = ApiResponse();

 try {
    String token = await getToken();
    int userId = await getUserId();

    final response = await http.post(Uri.parse(ApiConstants.addCartUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
                body:{
                       'user_id': userId.toString(),
                        'id' : product.id.toString(),
                        'item_price' : product.price.toString(),
                        'quantity' : "1"
                    },   
               );

    switch(response.statusCode)
    {
      case 200:
      apiResponse.data =  "Added to cart";
       print(apiResponse.data);
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

Future<ApiResponse> incrementCart(Cart cart) async{
  ApiResponse apiResponse = ApiResponse();

 try {
    String token = await getToken();
    int userId = await getUserId();

    final response = await http.post(Uri.parse(ApiConstants.addCartUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
                body:{
                       'user_id': userId.toString(),
                        'id' : cart.item_id.toString(),
                        'item_price' : cart.item_price.toString(),
                        'quantity' : "1"
                    },   
               );
    switch(response.statusCode)
    {
      case 200:
      apiResponse.data =  "Added to cart";
       print(apiResponse.data);
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

Future<ApiResponse> decrementCart(Cart cart) async{
  ApiResponse apiResponse = ApiResponse();
 try {
    String token = await getToken();
    int userId = await getUserId();

    final response = await http.post(Uri.parse(ApiConstants.removeCartUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
                body:{
                        'user_id': userId.toString(),
                        'item_id' : cart.item_id.toString(),
                        'item_price' : cart.item_price.toString(),
                        'quantity' : "1"
                    },   
               );
    print(response.statusCode);
    switch(response.statusCode)
    {
      case 200:
        apiResponse.data =  "Removed from cart";
        print(apiResponse.data);
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


Future<ApiResponse> getTotal() async{
  ApiResponse apiResponse = ApiResponse();
 try {
    String token = await getToken();
    int userId = await getUserId();

    final response = await http.post(Uri.parse(ApiConstants.getTotalUrl),
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
      print("Hellokjjksdfhjksdhfjkd");
      print(response.body);
        apiResponse.data =  jsonDecode(response.body);
        print(apiResponse.data);
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

 
}