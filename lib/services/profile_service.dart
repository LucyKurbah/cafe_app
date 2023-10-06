import 'dart:convert';
import 'dart:io';
import 'package:cafe_app/models/IdCard.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:http/http.dart' as http;
import '../api/apiFile.dart';
import '../models/ProfileModel.dart';
import '../screens/profile/profile.dart';
import 'api_response.dart';

Future<ApiResponse> getProfile() async {
  ApiResponse apiResponse = ApiResponse();
  String token = await getToken();
  int userId = await getUserId();

  print("USER ID____________________________________________________________________");
    print(userId);
  try { 
    final response = await http.post(
      Uri.parse(ApiConstants.getProfileUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'user_id': userId.toString(),
      },
    );
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        if (response.body == '305') {
          apiResponse.data = '';
        } else if (response.body == 'X') {
          apiResponse.error = ApiConstants.notLoggedIn;
        } else if (response.body == '450') {
          apiResponse.error = ApiConstants.notLoggedIn;
        } else if (response.body == '500') {
          apiResponse.error = ApiConstants.notLoggedIn;
        } else {
          apiResponse.data = jsonDecode(response.body)
              .map((p) => ProfileModel.fromJson(p))
              .toList();
        }
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

Future<ApiResponse> saveProfileDetailsApiCall(name, dropdownvalue) async {
  ApiResponse apiResponse = ApiResponse();
  String token = await getToken();
  int userId = await getUserId();

  try {
    //var response = await http.MultipartRequest('POST', Uri.parse(ApiConstants.saveProfileUrl));
    final response = await http.post(
      Uri.parse(ApiConstants.saveProfileUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'user_id': userId.toString(),
        'name' : name,
        'document_id': dropdownvalue
      },
    );
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        if (response.body == '305') {
          apiResponse.data = '';
        } else if (response.body == 'X') {
          apiResponse.error = ApiConstants.notLoggedIn;
        } else if (response.body == '500') {
          apiResponse.error = ApiConstants.notLoggedIn;
        } else {
         
          // apiResponse.data = jsonDecode(response.body)
          //     .map((p) => ProfileModel.fromJson(p))
          //     .toList();
          apiResponse.data = 'Updated';
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

Future<ApiResponse> uploadFile( String? fileName,String? fileData) async {
  ApiResponse apiResponse = ApiResponse();
  String token = await getToken();
  int userId = await getUserId();
  try {
   
    final response = await http.post(
      Uri.parse(ApiConstants.uploadProfileUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'user_id': userId.toString(),
        'data' : fileData,
        'fileName': fileName,
      },
    );

    switch (response.statusCode) {
      case 200:
        if (response.body == '305') {
          apiResponse.data = '';
        } else if (response.body == 'X') {
          apiResponse.error = ApiConstants.notLoggedIn;
        } else if (response.body == '500') {
          apiResponse.error = ApiConstants.notLoggedIn;
        } else {
         
          // apiResponse.data = jsonDecode(response.body)
          //     .map((p) => ProfileModel.fromJson(p))
          //     .toList();
          apiResponse.data = 'Updated';
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

Future<ApiResponse> getIDList() async{
  
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
  
    final response = await http.post(Uri.parse(ApiConstants.getIdDetailsUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
               );
    switch(response.statusCode)
    {
      case 200:
        apiResponse.data =  jsonDecode(response.body).map((p) => IdCard.fromJson(p)).toList();
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

Future<ApiResponse> deleteDocument() async{
  
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    int user_id = await getUserId();
    final response = await http.post(Uri.parse(ApiConstants.deleteDocumentUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
                body: {
                  'user_id' : user_id.toString(),
                }
               );
    print(response.statusCode);
    switch(response.statusCode)
    {
      case 200:
        apiResponse.data =  response.body;
        break;
      case 401:
        apiResponse.error = ApiConstants.unauthorized;
        break;
      case 404:
        apiResponse.error = response.statusCode.toString();
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
