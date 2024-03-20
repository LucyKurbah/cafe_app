import 'dart:convert';

import 'package:cafe_app/services/user_service.dart';
import 'package:http/http.dart' as http;
import '../api/apiFile.dart';
import 'api_response.dart';

Future<ApiResponse> saveDeviceToken(deviceTokenId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    int userId = await getUserId();
    final response = await http.post(Uri.parse(ApiConstants.updateDeviceToken),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'user_id': userId.toString(),
          'deviceTokenId': deviceTokenId.toString()
      },
    );
    switch (response.statusCode) {
      case 200:
          apiResponse.data = 200;       
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
