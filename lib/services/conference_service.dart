import 'dart:convert';

import 'package:cafe_app/services/table_service.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api/apiFile.dart';
import '../models/Order.dart';
import '../models/Conference.dart';
import 'api_response.dart';


Future<ApiResponse> getConference() async{
  
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
  
    final response = await http.post(Uri.parse(ApiConstants.getConferenceDetailsUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
               );
              
    switch(response.statusCode)
    {
      case 200:
        apiResponse.data =  jsonDecode(response.body).map((p) => Conference.fromJson(p)).toList();
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

convertDateToPostgres(bookDate){
    DateTime date = DateFormat('dd-MM-yyyy').parse(bookDate);
    print(date);
    String formattedDate = '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return('${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
   
  }

convertTimeToPostgres(time,bookDate){
    DateTime date = DateFormat('dd-MM-yyyy').parse(bookDate);
    DateTime ptime = DateFormat.jm().parse(time);
    DateTime postgresDateTime = DateTime(date.year, date.month, date.day, ptime.hour, ptime.minute, ptime.second);
    return postgresDateTime.toString();
  }


Future<ApiResponse> checkConferenceHallDetails(id, time_from, time_to, date) async{
  
  ApiResponse apiResponse = ApiResponse();
  try {
   
    String token = await getToken();
    int userId = await getUserId();
    String formattedDate=convertDateToPostgres(date);
    String timeFrom=convertTimeToPostgres(time_from,date);
    String timeTo=convertTimeToPostgres(time_to,date);
    final response = await http.post(Uri.parse(ApiConstants.checkConferenceDetailsUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
                body: {
                      'userId': userId.toString(),
                      'conference_id' : id.toString(),
                      'conference_time_from' : timeFrom,
                      'conference_time_to' : timeTo,
                      'conference_date' : formattedDate.toString()
                    },
               );
    print("object");
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
