import 'package:flutter/material.dart';

import 'package:cafe_app/constraints/constants.dart';
import 'package:cafe_app/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../api/apiFile.dart';
import '../../components/badge_widget.dart';
import '../../services/api_response.dart';
import '../../services/cart_service.dart';
import '../../services/conference_service.dart';
import '../../services/table_service.dart';
import '../../services/user_service.dart';
import '../../widgets/custom_widgets.dart';
import '../add_on/addOn_page.dart';
import '../cart/cartscreen.dart';
import 'package:badges/badges.dart';
import 'package:intl/intl.dart';
import '../user/login.dart';

class ConferenceScreen extends StatefulWidget {
  ConferenceScreen({super.key});

  @override
  State<ConferenceScreen> createState() => _ConferenceScreenState();
}

class _ConferenceScreenState extends State<ConferenceScreen> {
  
  TextEditingController _date = TextEditingController();
  TextEditingController _selectedtimeFrom = TextEditingController();
  TextEditingController _selectedtimeTo = TextEditingController();
  TextEditingController noOfHours = TextEditingController();
  int hours=0,minutes =0;
  int userId = 0;
  bool _loading = true;
  String t_date = '';
  TimeOfDay? timeFrom, timeTo;
  String _cartMessage = '';
  bool checkTable =false;

  List<dynamic> _conferenceList = [].obs;

  @override
  void initState(){
    super.initState();
    retrieveConference();
  }

  
  Future<void> retrieveConference() async{
    userId = await getUserId();
    ApiResponse response = await getConference();
    if(response.error == null)
    {
      setState(() {
        _conferenceList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if(response.error == ApiConstants.unauthorized){
            logoutUser();
             Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                                      builder: (context) => Login()
                                                                ), 
                                                (route) => false);
      
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }
   

  void _updateSecondTimePicker(TimeOfDay newTime) {
    if (timeFrom != null && newTime != null && newTime.hour < timeFrom!.hour) {
      showSnackBar(
          title: 'Invalid Time',
          message: 'Please enter a time after ${timeFrom!.format(context)}');
      newTime = TimeOfDay(hour: timeFrom!.hour, minute: newTime.minute);
    }
    if (timeFrom != null &&
        newTime != null &&
        newTime.hour == timeFrom!.hour &&
        newTime.minute < timeFrom!.minute) {
      newTime = TimeOfDay(hour: timeFrom!.hour, minute: timeFrom!.minute);
    }
    DateTime parsedTime =
        DateFormat.jm().parse(newTime.format(context).toString());

    String formattedTime = DateFormat('h:mm a').format(parsedTime);

    setState(() {
      _selectedtimeTo.text = formattedTime;
      calculateHours(_selectedtimeFrom.text, formattedTime);
      checkDateTimeAvailability(_conferenceList[0].id, _selectedtimeFrom.text, formattedTime);
    });
  }

  convertTimeToPostgres(time,bookDate){
    DateTime date = DateFormat('yyyy-MM-dd').parse(bookDate);
    DateTime ptime = DateFormat.jm().parse(time);
    DateTime postgresDateTime = DateTime(date.year, date.month, date.day, ptime.hour, ptime.minute, ptime.second);
    return postgresDateTime.toString();
  }

  Future<void> addCart(id, String totalPrice, String date, String timeFrom, String timeTo) async{
    userId = await getUserId();
    DateTime time_from = DateFormat('h:mm a').parse(timeFrom);
    DateTime time_to = DateFormat('h:mm a').parse(timeTo);
    String bookDate =convertTimeToPostgres(timeFrom,date);
    ApiResponse response = await addConferenceToCart(id, totalPrice, bookDate, time_from.toString(), time_to.toString());
    if(response.error == null)
    {
      if(response.data==200)
      {
          setState(() {
            //add the counter here
            //incrementCount();
            _cartMessage = "Conference Hall added to Cart";
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${_cartMessage}"),duration: Duration(seconds: 1)));
            _loading = _loading ? !_loading : _loading;
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                                          builder: (context) => AddOnPage()
                                                                    ), 
                                                    (route) => false);
          });
      }
      else if(response.data=="X")
      {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Table is not available for the selected time")));
      }
     
    }
    else if(response.error == ApiConstants.unauthorized){
          logoutUser();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                                      builder: (context) => Login()
                                                                ), 
                                                (route) => false);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    height: size.height *0.4,
                    color: Colors.white,
                    child:  Hero(
                      tag: '',
                      child: Image.asset(
                                   "Assets/Images/cafe3.jpg",
                                   fit: BoxFit.fill
                                  ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height *0.3),
                    height: size.height ,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40), 
                              topRight: Radius.circular(40))
                    ),
                    child:               
                    Padding(
                          padding: EdgeInsets.only(left: 25, right: 40, top: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                              "Conference Hall",
                                style: TextStyle(
                                  fontSize: 30,
                                  letterSpacing: 1,
                                  color: Colors.white
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.grey[600], size: 20,),
                                  Icon(Icons.star, color: Colors.grey[600], size: 20),
                                  Icon(Icons.star, color: Colors.grey[600], size: 20),
                                  Icon(Icons.star, color: Colors.grey[600], size: 20),
                                  Icon(Icons.star, color: Colors.grey[600], size: 20),
                                ],
                              ),              
                              SizedBox(height: 20),
                               Text(_conferenceList.isNotEmpty?"PRICE: Rs. ${_conferenceList[0].price} /hr":"",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color : Colors.white  
                                      )),

                              SizedBox(height: 50,),
                               Container(
                              height: 110,
                              child: Column(
                                children: [
                                  Flexible(
                                    child: TextField(
                                      controller: _date,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        icon: Icon(Icons.calendar_month_sharp,
                                            color: Colors.white),
                                        labelText: "Select Date",
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickeddate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2024));
                                        if (pickeddate != null) {
                                          setState(() {
                                            _date.text = DateFormat('dd-MM-yyyy').format(pickeddate);
                                            t_date = DateFormat('yyyy-MM-dd').format(pickeddate);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextField(
                                            controller: _selectedtimeFrom,
                                            style:
                                                TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              icon: Icon(
                                                  Icons.calendar_month_sharp,
                                                  color: Colors.white),
                                              labelText: "Select Time From",
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            readOnly: true,
                                            onTap: () async {
                                              timeFrom = (await showTimePicker(
                                                initialEntryMode:
                                                    TimePickerEntryMode.dial,
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                                builder:
                                                    (context, Widget? child) {
                                                  return MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                            alwaysUse24HourFormat:
                                                                false),
                                                    child: child!,
                                                  );
                                                },
                                              ))!;
                                              if (timeFrom != null) {
                                                try {
                                                  DateTime parsedTime =
                                                      DateFormat.jm().parse(
                                                          timeFrom!
                                                              .format(context)
                                                              .toString());
                                                  String formattedTime =
                                                      DateFormat('h:mm a')
                                                          .format(parsedTime);

                                                  setState(() {
                                                    _selectedtimeFrom.text =
                                                        formattedTime;
                                                  });
                                                } on FormatException catch (_, e) {
                                                  print(
                                                      "Error parsing timeFrom string: ${e.toString()}");
                                                }
                                              }
                                            }),
                                      ),
                                      Flexible(
                                        child: TextField(
                                            controller: _selectedtimeTo,
                                            style:
                                                TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              icon: Icon(
                                                  Icons.calendar_month_sharp,
                                                  color: Colors.white),
                                              labelText: "Select Time To",
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            readOnly: true,
                                            onTap: () async {
                                              timeTo = (await showTimePicker(
                                                initialEntryMode:
                                                    TimePickerEntryMode.dial,
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                                builder:
                                                    (context, Widget? child) {
                                                  return MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                            alwaysUse24HourFormat:
                                                                false),
                                                    child: child!,
                                                  );
                                                },
                                              ))!;
                                              if (timeTo != null) {
                                                try {
                                                  setState(() {
                                                    _updateSecondTimePicker(
                                                        timeTo!);
                                                  });
                                                } on FormatException catch (_, e) {
                                                  print(
                                                      "Error parsing timeTo string: ${e.toString()}");
                                                }
                                              }
                                            }),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                            noOfHours.text.isNotEmpty ?Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(16.0),
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                     Text("No of hours: $hours",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white)),
                                            SizedBox(height: 8.0),
                                       
                                      Text("TOTAL PRICE: Rs."+ noOfHours.text,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white))
                                              ],
                                            ),
                                          ) 
                              : SizedBox.shrink(),
                               SizedBox(height:10),
                              noOfHours.text.isNotEmpty && checkTable?Center(
                                child: 
                                    Container(          
                                      alignment: Alignment.center,
                                      child:
                                      // (checkTable)?
                                              StatefulBuilder(
                                                builder: (context, setState) {
                                                  return ElevatedButton(                                                  
                                                         style: ButtonStyle(                                                           
                                                             backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 50, 54, 56)),
                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(18.0),
                                                                  ),                                                              
                                                                ),                                                               
                                                          ),                                                                                                                        
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                                            child: Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                                          ),
                                                          onPressed:  (){
                                                            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => CartScreen()));
                                                             addCart(_conferenceList.isNotEmpty?_conferenceList[0].id:0,noOfHours.text, t_date, _selectedtimeFrom.text.toString(), _selectedtimeTo.text.toString());
                                                            },
                                                          );
                                                }
                                              )
                                    ),
                              )
                              :
                               Center(
                                child: ElevatedButton(                                                  
                                          style: ButtonStyle(                                                           
                                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 50, 54, 56)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(18.0),
                                                  ),                                                              
                                                ),                                                               
                                          ),                                                                                                                        
                                          child: Padding(
                                                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                                              child: Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                                            ),
                                                            onPressed:  (){
                                                              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => CartScreen()));
                                                              //  addCart(widget.table, noOfHours.text, t_date, _selectedtimeFrom.text.toString(), _selectedtimeTo.text.toString());
                                                              showSnackBar(
                                                                        title: 'The Time slot is not available',
                                                                        message: '');
                                                              },
                                                            ),
                              )
                            ],
                          ),
                        )
                  ),
                 
                ],
              ),
              )
            ],
          ),
        ),
    );
  }
  
  void calculateHours(String timeString1, String timeString2) {
      // Parse the time strings into DateTime objects
      DateTime time1 = DateFormat('h:mm a').parse(timeString1);
      DateTime time2 = DateFormat('h:mm a').parse(timeString2);

      // Calculate the duration between the two DateTime objects
      Duration difference = time2.difference(time1);

      // Get the difference in hours
      hours = difference.inHours;

      // Get the difference in hours
      minutes = difference.inMinutes.remainder(60);
      print('The difference between $timeString1 and $timeString2 is $hours hours and $minutes minutes');
      if (minutes > 0) {
        hours += 1;
      }
      else if(hours == 0)
      {
        hours = 1;
      }
      var price =_conferenceList.isNotEmpty?_conferenceList[0].price:1;
      noOfHours.text = (hours * price).toString();
      // print('The difference between $timeString1 and $timeString2 is $hours hours and $minutes minutes');
   }
  
  buildAppBar(context) {
    return AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right:defaultPadding, left: defaultPadding),
              child: Center(
                child: BadgeWidget(),
              ),
            )

          ],
        );
  }

  void _loadUserInfo(context) async{
    String token = await getToken();

    if(token == ''  || token == null)
    {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false);
    }
    else{
      ApiResponse response = await getUserDetails();
      print(response.data);
      if(response.error == null)
      {
        
      }
      else if(response.error == ApiConstants.unauthorized)
      {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>Login()), (route) => false);
      }
      else
      {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
        ));
      }
    }
  }

  void checkDateTimeAvailability(id, String timeFrom, String timeTo)  async {
    print("Hello");
    ApiResponse response = await checkConferenceHallDetails(id, timeFrom, timeTo, _date.text);
    if (response.error == null) {
      
      if(response.data != null)
      {
        if(response.data.toString()=="VE")
        {
          print("Validation Error");
           setState(() {
               checkTable=false;
            });
        }
        else if(response.data=="Y")
        {
            print("Time and date available");
            setState(() {
               checkTable=true;
            });
        }
        else if(response.data=="X")
        {
            print("Time and date not available");
            showSnackBar(title: '',message: 'The Time slot is not available');
            setState(() {
               checkTable=false;
            });
        }
      }
      else{
        showSnackBar(title: '',message: 'The Time slot is not available');
        setState(() {
               checkTable=false;
        });
      }
    } else if (response.error == ApiConstants.unauthorized) {
       checkTable=false;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    } else {
       checkTable=false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
}


