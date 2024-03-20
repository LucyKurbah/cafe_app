import 'package:cafe_app/models/Table.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/apiFile.dart';
import '../models/AddOn.dart';
import '../models/Product.dart';
import '../models/Cart.dart';
import '../models/TableCart.dart';
import 'api_response.dart';
import 'user_service.dart';

Future<ApiResponse> getCart() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    int userId = await getUserId();
    final response = await http.post(
      Uri.parse(ApiConstants.cartUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'user_id': userId.toString(),
      },
    );

    switch (response.statusCode) {
      case 200:
        if (response.body == '305') {
          apiResponse.data = ''; //User not logged in
        } else {
          apiResponse.data =
              jsonDecode(response.body).map((p) => Cart.fromJson(p)).toList();
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
    apiResponse.error = e.toString();
  }
  return apiResponse;
}

Future<ApiResponse> getTableCart() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    int userId = await getUserId();
    final response = await http.post(
      Uri.parse(ApiConstants.tableCartUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'user_id': userId.toString(),
      },
    );
    
    switch (response.statusCode) {
      case 200:

        if (response.body == '305') {
          apiResponse.data = ''; //User not logged in
        } else {
          apiResponse.data =
              jsonDecode(response.body).map((p) => TableCart.fromJson(p)).toList();
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
    apiResponse.error = e.toString();
  }
  return apiResponse;
}

Future<ApiResponse> addToCart(Product product) async {
  ApiResponse apiResponse = ApiResponse();
  String token = await getToken();
  int userId = await getUserId();
  if (userId == 0 || userId == null) {
    apiResponse.error = "Please log in first";
  } else {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.addCartUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'user_id': userId.toString(),
          'food_id': product.id.toString(),
          'food_price': product.price.toString(),
          'food_quantity': "1",
          'flag': 'F'
        },
      );
      switch (response.statusCode) {
        case 200:
          apiResponse.data = "Added to cart";
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
      apiResponse.error = e.toString();
    }
  }
  return apiResponse;
}

Future<ApiResponse> addItemToCart(AddOn item) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    int userId = await getUserId();
    if (userId == '' || userId == 0) {
      apiResponse.error = ApiConstants.notLoggedIn;
      return apiResponse;
    }

    final response = await http.post(
      Uri.parse(ApiConstants.addCartUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'user_id': userId.toString(),
        'item_id': item.id.toString(),
        'item_price': item.price.toString(),
        'item_quantity': "1",
        'flag': 'I'
      },
    );
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = "Added to cart";
        print(apiResponse.data);
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
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> removeItemFromCart(AddOn item) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    int userId = await getUserId();

    final response = await http.post(
      Uri.parse(ApiConstants.removeCartUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'user_id': userId.toString(),
        'item_id': item.id.toString(),
        'item_quantity': "1",
        'flag': 'I'
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = "Removed From cart";
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
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> addTableToCart(String date, String timeFrom, String timeTo, List<int> selectedTables, String hours) async {
  String  tableIds= selectedTables.join(',');

  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    int userId = await getUserId();
    final response = await http.post(
        Uri.parse(ApiConstants.addCartUrl),
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
        body: {
          'user_id': userId.toString(),
          'table_id': tableIds.toString(),
          'table_hours': (hours.toString()),
          'table_date': date,
          'table_time_from': timeFrom,
          'table_time_to': timeTo,
          'flag': 'T'
      },
    );
    switch (response.statusCode) {
      case 200:
        if(response.body == '350'){
          apiResponse.data = 350;
        }else{
          apiResponse.data = jsonDecode(response.body);
        }
        break;
      case 500:
          apiResponse.error = ApiConstants.unauthorized;
          break;
      default:
          apiResponse.error = response.statusCode.toString();
          print(response.statusCode.toString());
        break;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }
  return apiResponse;
}

Future<ApiResponse> addConferenceToCart(
    id, String totalPrice, String date, String timeFrom, String timeTo) async {
  ApiResponse apiResponse = ApiResponse();
  String token = await getToken();
  int userId = await getUserId();
  if (userId != 0 && userId != null) {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.addCartUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'user_id': userId.toString(),
          'conference_id': id.toString(),
          'conference_price': totalPrice,
          'conference_date': date,
          'conference_time_from': timeFrom,
          'conference_time_to': timeTo,
          'flag': 'C'
        },
      );
      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body);
          // apiResponse.data =  "Added to cart";
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
      apiResponse.error = e.toString();
    }
  } else {
    apiResponse.error = "User not logged in";
  }
  return apiResponse;
}

Future<ApiResponse> addEntireFloorToCart(int id, String date) async {
  ApiResponse apiResponse = ApiResponse();
  String token = await getToken();
  int userId = await getUserId();
  if (userId != 0 && userId != null) {
    try {
      print(userId.toString());
      print(id.toString());
      print(date);

      final response = await http.post(
        Uri.parse(ApiConstants.addCartUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'user_id': userId.toString(),
          'floor_id': id.toString(),
          'floor_date': date,
          'flag': 'E'
        },
      );
      print(response.body);
      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body);
          if (apiResponse.data == 500) {
            apiResponse.error = response.statusCode.toString();
          }
          // apiResponse.data =  "Added to cart";
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
      apiResponse.error = e.toString();
    }
  } else {
    apiResponse.error = "User not logged in";
  }
  return apiResponse;
}

Future<ApiResponse> incrementCart(Cart cart) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    int userId = await getUserId();
    String id = '';
    if (cart.flag.toString() == 'F') {
      id = 'food_id';
    } else if (cart.flag.toString() == 'T') {
      id = 'table_id';
    } else {
      id = 'item_id';
    }
    final response = await http.post(
      Uri.parse(ApiConstants.addCartUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'user_id': userId.toString(),
        id: cart.item_id.toString(),
        'item_price': cart.item_price.toString(),
        'quantity': "1",
        'flag': cart.flag.toString(),
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = "Added to cart";
        break;
      case 401:
        apiResponse.error = ApiConstants.unauthorized;
        break;
      default:
        apiResponse.error = response.statusCode.toString();
        break;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> decrementCart(Cart cart) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    int userId = await getUserId();
    String id = '';
    if (cart.flag.toString() == 'F') {
      id = 'food_id';
    } else if (cart.flag.toString() == 'T') {
      id = 'table_id';
    } else if (cart.flag.toString() == 'C') {
      id = 'conference_id';
    } else {
      id = 'item_id';
    }

    final response = await http.post(
      Uri.parse(ApiConstants.removeCartUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'user_id': userId.toString(),
        id: cart.item_id.toString(),
        'item_price': cart.item_price.toString(),
        'quantity': "1",
        'flag': cart.flag
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = "Removed from cart";
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
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> getTotal() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    int userId = await getUserId();

    final response = await http.post(
      Uri.parse(ApiConstants.getTotalUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'user_id': userId.toString(),
      },
    );

    switch (response.statusCode) {
      case 200:
        String responseString = (jsonDecode(response.body));
        double value = double.parse(responseString);
        apiResponse.data = value;
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
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> saveOrder(cartList, totalPrice) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    int userId = await getUserId();

    final response = await http.post(
      Uri.parse(ApiConstants.saveOrder),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'user_id': userId.toString(),
      },
    );
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body));
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
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> makePayment() async {
  ApiResponse apiResponse = ApiResponse();
  String token = await getToken();
  int userId = await getUserId();
  try {
    final response = await http.post(
      Uri.parse(ApiConstants.makePayment),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'user_id': userId.toString(),
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body == '200') {
        print(response.body);
        apiResponse.data = 200; //Payment successful
      } else {
        print("Payment failed");
        apiResponse.error = "Payment failed";
      }
    } else {
      apiResponse.error = "Payment failed";
      print(apiResponse.error);
      // throw Exception("Payment failed");
    }
    print(apiResponse.data);
    return apiResponse;
  } catch (e) {
    // Handle the error
    throw Exception(e.toString());
  }
}
