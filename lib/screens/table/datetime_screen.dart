import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:cafe_app/constraints/constants.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/models/Table.dart';
import 'package:cafe_app/widgets/custom_widgets.dart';
import '../../api/apiFile.dart';
import '../../components/badge_widget.dart';
import '../../services/api_response.dart';
import '../../services/cart_service.dart';
import '../../services/user_service.dart';
import '../../services/table_service.dart';
import '../add_on/addOn_page.dart';
import 'package:intl/intl.dart';

import '../user/login.dart';

class DateTimeScreen extends StatefulWidget {
  DateTimeScreen(this.table, {super.key});

  TableModel table;

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  final TextEditingController _date = TextEditingController();
  final TextEditingController _selectedtimeFrom = TextEditingController();
  final TextEditingController _selectedtimeTo = TextEditingController();
  TextEditingController noOfHours = TextEditingController();
  int hours = 0, minutes = 0;

  TimeOfDay? timeFrom, timeTo;

  int userId = 0;
  bool _loading = true;
  String _cartMessage = '';
  bool checkTable = false;
  String t_date = '';

  void _updateSecondTimePicker(TimeOfDay newTime) {
    // print("Checking the Time to");
    // print(newTime);
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
        DateFormat.Hm().parse(newTime.format(context).toString());
    // print(parsedTime);
    String formattedTime = DateFormat('h:mm a').format(parsedTime);

    setState(() {
      _selectedtimeTo.text = formattedTime;
      
      calculateHours(_selectedtimeFrom.text, formattedTime);
      checkDateTimeAvailability(
          widget.table.id, _selectedtimeFrom.text, formattedTime);
    });
  }

  convertTimeToPostgres(time, bookDate) {
    DateTime date = DateFormat('yyyy-MM-dd').parse(bookDate);
    DateTime ptime = DateFormat.jm().parse(time);
    DateTime postgresDateTime = DateTime(date.year, date.month, date.day,
        ptime.hour, ptime.minute, ptime.second);
    return postgresDateTime.toString();
  }

  Future<void> addCart(TableModel table, String totalPrice, String date,
      String timeFrom, String timeTo) async {
    userId = await getUserId();
    DateTime time_from = DateFormat('h:mm a').parse(timeFrom);
    DateTime time_to = DateFormat('h:mm a').parse(timeTo);
    String bookDate = convertTimeToPostgres(timeFrom, date);
    ApiResponse response = await addTableToCart(
        table, totalPrice, bookDate, time_from.toString(), time_to.toString());

    if (response.error == null) {
      if (response.data == 200) {
        setState(() {
          //add the counter here
          //incrementCount();
          _cartMessage = "Table added to Cart";
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(_cartMessage)));
          _loading = _loading ? !_loading : _loading;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AddOnPage()),
              (route) => false);
        });
      } else if (response.data == "X") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Table is not available for the selected time")));
      }
    } else if (response.error == ApiConstants.unauthorized) {
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: mainColor,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    height: size.height * 0.4,
                    color: textColor,
                    child: Hero(
                      tag: '${widget.table.id}',
                      child:
                          Image.network(widget.table.image, fit: BoxFit.fill),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: size.height * 0.3),
                      height: size.height,
                      decoration: BoxDecoration(
                          color: greyColor9,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 25, right: 40, top: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.table.table_name,
                              style: TextStyle(
                                  fontSize: 30,
                                  letterSpacing: 1,
                                  color: textColor),
                            ),
                            SizedBox(
                              height: Dimensions.height10,
                            ),
                            Text("${widget.table.table_seats} seats",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: textColor.withOpacity(0.8))),
                            SizedBox(height: Dimensions.height30),
                            Text("Rs. ${widget.table.price} /hr",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: textColor)),
                            SizedBox(
                              height: Dimensions.height10,
                            ),
                            Divider(
                              color: textColor.withOpacity(0.5),
                            ),
                            SizedBox(
                              height: 110,
                              child: Column(
                                children: [
                                  Flexible(
                                    child: TextField(
                                      controller: _date,
                                      style: TextStyle(color: textColor),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: textColor),
                                        ),
                                        icon: Icon(Icons.calendar_month_sharp,
                                            color: textColor),
                                        labelText: "Select Date",
                                        labelStyle: TextStyle(color: textColor),
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        
                                        DateTime currentDate = DateTime.now();

                                        DateTime? pickeddate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: currentDate,
                                                firstDate: currentDate,
                                                lastDate: currentDate.add(Duration(days: 365)));
                                        if (pickeddate != null) {
                                          setState(() {
                                            _date.text =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(pickeddate);
                                            t_date = DateFormat('yyyy-MM-dd')
                                                .format(pickeddate);
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
                                            style: TextStyle(color: textColor),
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: textColor),
                                              ),
                                              icon: Icon(
                                                  Icons.timelapse_outlined,
                                                  color: textColor),
                                              labelText: "From",
                                              labelStyle:
                                                  TextStyle(color: textColor),
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
                                                      DateFormat.Hm().parse(
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
                                            style: TextStyle(color: textColor),
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: textColor),
                                              ),
                                              icon: Icon(
                                                  Icons.timelapse_outlined,
                                                  color: textColor),
                                              labelText: "To",
                                              labelStyle:
                                                  TextStyle(color: textColor),
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
                            SizedBox(
                              height: Dimensions.height30,
                            ),
                            noOfHours.text.isNotEmpty
                                ? Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.all(16.0),
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("No of hours: $hours",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                                color: textColor)),
                                        SizedBox(height: Dimensions.height10),
                                        Text(
                                            "TOTAL PRICE: Rs.${noOfHours.text}",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w400,
                                                color: textColor))
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            SizedBox(height: Dimensions.height10),
                            noOfHours.text.isNotEmpty && checkTable
                                ? Center(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child:
                                            // (checkTable)?
                                            StatefulBuilder(
                                                builder: (context, setState) {
                                          return ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      grey9Button),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                              child: Text('Add to Cart',
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1)),
                                            ),
                                            onPressed: () {
                                              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => CartScreen()));
                                              addCart(
                                                  widget.table,
                                                  noOfHours.text,
                                                  t_date,
                                                  _selectedtimeFrom.text
                                                      .toString(),
                                                  _selectedtimeTo.text
                                                      .toString());
                                            },
                                          );
                                        })),
                                  )
                                :
                                // SizedBox.shrink(),

                                Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                grey9Button),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: Text('Add to Cart',
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1)),
                                      ),
                                      onPressed: () {
                                        showSnackBar(
                                            title:
                                                'The Time slot is not available',
                                            message: '');
                                      },
                                    ),
                                  )
                          ],
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  buildAppBar(context) {
    return AppBar(
      backgroundColor: mainColor,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: defaultPadding, left: defaultPadding),
          child: Center(
            child: BadgeWidget(),
          ),
        )
      ],
    );
  }

  void checkDateTimeAvailability(
    tableId, String timeFrom, String timeTo) async {
    ApiResponse response =
        await getTableDetails(tableId, timeFrom, timeTo, _date.text);

    if (response.error == null) {
      if (response.data != null) {
        if (response.data.toString() == "VE") {
          print("Validation Error");
          setState(() {
            checkTable = false;
          });
        } else if (response.data == 200) {
          print("Time and date available");
          setState(() {
            checkTable = true;
          });
        } else if (response.data == 300) {
          print("Time and date not available");
          showSnackBar(title: '', message: 'The Time slot is not available');
          setState(() {
            checkTable = false;
          });
        } else if (response.data == 310) {
          print("Date not available");
          showSnackBar(title: '', message: 'The Date is fully booked');
          setState(() {
            checkTable = false;
          });
        }
      } else {
        showSnackBar(title: '', message: 'The Time slot is not available');
        setState(() {
          checkTable = false;
        });
      }
    } else if (response.error == ApiConstants.unauthorized) {
      checkTable = false;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    } else {
      checkTable = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
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
    // print('The difference between $timeString1 and $timeString2 is $hours hours and $minutes minutes');
    if (minutes > 0) {
      hours += 1;
    } else if (hours == 0) {
      hours = 1;
    }
    noOfHours.text = (hours * widget.table.price).toString();
    // print('The difference between $timeString1 and $timeString2 is $hours hours and $minutes minutes');
  }
}
