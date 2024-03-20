
import 'dart:convert';

import 'package:cafe_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api/apiFile.dart';
import '../models/Table.dart';
import 'api_response.dart';


Future<ApiResponse> getAvailableTables(DateTime date, TimeOfDay time) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    
    // Convert date and time to the required format
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    String formattedTime = '${time.hour}:${time.minute}';

    final response = await http.post(
      Uri.parse(ApiConstants.availableTablesUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'date': formattedDate,
        'time': formattedTime,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)
            .map((p) => TableModel.fromJson(p))
            .toList();
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


Future<ApiResponse> getTables() async{
  
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(ApiConstants.tableUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
               );
  
    switch(response.statusCode)
    {
      case 200:
      print(response.body);
        apiResponse.data =  jsonDecode(response.body).map((p) => TableModel.fromJson(p)).toList();
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
convertDateToPostgres(bookDate){
    DateTime date = DateFormat('dd-MM-yyyy').parse(bookDate);
    print(date);
    return('${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
  }

convertTimeToPostgres(time,bookDate){
    DateTime date = DateFormat('dd-MM-yyyy').parse(bookDate);
    DateTime ptime = DateFormat.jm().parse(time);
    DateTime postgresDateTime = DateTime(date.year, date.month, date.day, ptime.hour, ptime.minute, ptime.second);
    String postgresString = postgresDateTime.toString();
  int dotIndex = postgresString.indexOf('.');
  if (dotIndex != -1) {
    postgresString = postgresString.substring(0, dotIndex); // Remove everything after the decimal point
  }
  return postgresString;
  }


Future<ApiResponse> getTableDetails(table_id, timeFrom, timeTo, bookDate) async{
  
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    String formattedDate=convertDateToPostgres(bookDate);
    String time_from = (convertTimeToPostgres(timeFrom,bookDate));
    String time_to = (convertTimeToPostgres(timeTo,bookDate));

    // print(time_from);
    // print(time_to);
    // print(formattedDate);

    final response = await http.post(Uri.parse(ApiConstants.getTableDetailsUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
                body: {
                      'table_id': table_id.toString(),
                      'timeFrom' : time_from,
                      'timeTo' : time_to,
                      'bookDate' : formattedDate.toString()
                    },
               );
  print("Validate");
   print(response.statusCode);
    switch(response.statusCode)
    {
      case 200:
        print(response.body);
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

Future<ApiResponse> getTableDateTimeDetails( timeFrom, timeTo, bookDate) async{
  
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    String formattedDate=convertDateToPostgres(bookDate);
    String time_from = (convertTimeToPostgres(timeFrom,bookDate));
    String time_to = (convertTimeToPostgres(timeTo,bookDate));
    final response = await http.post(Uri.parse(ApiConstants.getTableDateTimeDetailsUrl),
                headers: {
                    'Accept' : 'application/json',
                    'Authorization' : 'Bearer $token'
                },
                body: {
                      
                      'timeFrom' : time_from,
                      'timeTo' : time_to,
                      'bookDate' : formattedDate.toString()
                    },
               );

    switch(response.statusCode)
    {
      case 200:      
         apiResponse.data =  jsonDecode(response.body).map((p) => TableModel.fromJson(p)).toList();
         print("TABLE DETAILS");
         print(response.body);
        break;
      case 401:
        apiResponse.error = ApiConstants.unauthorized;
        break;
      case 500:
        apiResponse.error = ApiConstants.noTable;
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

