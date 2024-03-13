import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/controllers/home_controller.dart';
import 'package:cafe_app/screens/home/components/table_card.dart';
import 'package:cafe_app/screens/user/login.dart';
import 'package:cafe_app/services/table_service.dart';
import 'package:cafe_app/services/cart_service.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/services/api_response.dart';
import 'package:intl/intl.dart';
import '../../components/badge_widget.dart';
import 'package:cafe_app/api/apiFile.dart';
import 'package:cafe_app/models/Product.dart';
import 'package:cafe_app/screens/table/single_table_screen.dart';
import 'package:get/get.dart';

import '../../models/Table.dart';
import '../../widgets/custom_widgets.dart';

class TablePage extends StatefulWidget {
  TablePage({super.key});

  // TableModel table;

  @override
  State<TablePage> createState() => _TablePageState();
}

class SeatWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            blueGrey, // You can change the color based on seat status (booked, available, etc.)
      ),
    );
  }
}

class _TablePageState extends State<TablePage> with TickerProviderStateMixin {
  final controller = HomeController();
  int userId = 0;
  bool _loading = true;
  List<dynamic> _productList = [].obs;
  String _cartMessage = '';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _selectedtimeFrom = TextEditingController();
  final TextEditingController _selectedtimeTo = TextEditingController();
  TextEditingController noOfHours = TextEditingController();
  int hours = 0, minutes = 0;

  TimeOfDay? timeFrom, timeTo;
  bool checkTable = false;
  String t_date = '';

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
        DateFormat.Hm().parse(newTime.format(context).toString());

    String formattedTime = DateFormat('h:mm a').format(parsedTime);

    setState(() {
      _selectedtimeTo.text = formattedTime;

      // calculateHours(_selectedtimeFrom.text, formattedTime);
      // checkDateTimeAvailability(_selectedtimeFrom.text, formattedTime);
    });
  }

  convertTimeToPostgres(time, bookDate) {
    DateTime date = DateFormat('yyyy-MM-dd').parse(bookDate);
    DateTime ptime = DateFormat.jm().parse(time);
    DateTime postgresDateTime = DateTime(date.year, date.month, date.day,
        ptime.hour, ptime.minute, ptime.second);
    return postgresDateTime.toString();
  }

  @override
  void initState() {
    super.initState();
    // retrieveProducts();
    // retrieveTables(selectedDate, selectedTime);
  }

  Future<void> retrieveTables(DateTime date, TimeOfDay time) async {
    userId = await getUserId();
    ApiResponse response = await getAvailableTables(date, time);
    if (response.error == null) {
      setState(() {
        _productList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        retrieveTables(selectedDate, selectedTime);
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
        retrieveTables(selectedDate, selectedTime);
      });
  }

  Future<void> retrieveProducts() async {
    userId = await getUserId();
    ApiResponse response = await getTables();
    if (response.error == null) {
      setState(() {
        _productList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
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

  Future<void> addCart(Product product) async {
    userId = await getUserId();

    ApiResponse response = await addToCart(product);
    if (response.error == null) {
      setState(() {
        //add the counter here
        //incrementCount();
        _cartMessage = response.data.toString();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_cartMessage)));
        _loading = _loading ? !_loading : _loading;
      });
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
    return Scaffold(
        backgroundColor: greyColor9,
        appBar: AppBar(
          backgroundColor: mainColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Center(child: BadgeWidget()),
            )
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              await retrieveTables(selectedDate, selectedTime);
            },
            child: SafeArea(
              bottom: false,
              child: Container(
                color: mainColor,
                child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      return LayoutBuilder(
                        builder: (context, BoxConstraints constraints) {
                          return Stack(
                            children: [
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 500),
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Text("Select Date and time",
                                        //     style: TextStyle(
                                        //         fontSize: 14,
                                        //         fontWeight: FontWeight.w500,
                                        //         color:
                                        //             textColor.withOpacity(0.5))),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: TextField(
                                                controller: _date,
                                                style:
                                                    TextStyle(color: textColor),
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: textColor),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            textColor), // Change this to your desired color
                                                  ),
                                                  icon: Icon(
                                                    Icons.calendar_month_sharp,
                                                    color: textColor,
                                                  ),
                                                  labelText: "Select Date",
                                                  labelStyle: TextStyle(
                                                      color: textColor),
                                                  hintText:
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(selectedDate),
                                                ),
                                                readOnly: true,
                                                onTap: () async {
                                                  DateTime currentDate =
                                                      DateTime.now();
                                                  DateTime? pickeddate =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: selectedDate,
                                                    firstDate: currentDate,
                                                    lastDate: currentDate.add(
                                                        Duration(days: 365)),
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      return Theme(
                                                        data: ThemeData.light()
                                                            .copyWith(
                                                          primaryColor:
                                                              redColor, // Change this to your desired color
                                                          hintColor:
                                                              redColor, // Change this to your desired color
                                                          colorScheme:
                                                              ColorScheme.light(
                                                                  primary:
                                                                      redColor),
                                                          buttonTheme:
                                                              ButtonThemeData(
                                                            textTheme:
                                                                ButtonTextTheme
                                                                    .primary,
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    },
                                                  );
                                                  if (pickeddate != null) {
                                                    setState(() {
                                                      selectedDate = pickeddate;
                                                      _date.text = DateFormat(
                                                              'dd-MM-yyyy')
                                                          .format(selectedDate);
                                                      // Update your logic here if needed
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: TextField(
                                                  controller: _selectedtimeFrom,
                                                  style: TextStyle(
                                                      color: textColor),
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: textColor),
                                                    ),
                                                    icon: Icon(
                                                        Icons
                                                            .timelapse_outlined,
                                                        color: textColor),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              textColor), // Change this to your desired color
                                                    ),
                                                    labelText: "From",
                                                    labelStyle: TextStyle(
                                                        color: textColor),
                                                  ),
                                                  readOnly: true,
                                                  onTap: () async {
                                                    timeFrom =
                                                        (await showTimePicker(
                                                      initialEntryMode:
                                                          TimePickerEntryMode
                                                              .dial,
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                      builder: (context,
                                                          Widget? child) {
                                                        return Theme(
                                                          data: ThemeData(
                                                            textButtonTheme:
                                                                TextButtonThemeData(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                foregroundColor:
                                                                    redColor, // Change this to your desired color
                                                              ),
                                                            ),
                                                            colorScheme:
                                                                ColorScheme
                                                                    .light(
                                                              primary:
                                                                  redColor, // Hour text color
                                                              onPrimary: Colors
                                                                  .white, // AM/PM text color
                                                            ),
                                                          ),
                                                          child: MediaQuery(
                                                            data: MediaQuery.of(
                                                                    context)
                                                                .copyWith(
                                                                    alwaysUse24HourFormat:
                                                                        false),
                                                            child: child!,
                                                          ),
                                                        );
                                                      },
                                                    ))!;
                                                    if (timeFrom != null) {
                                                      try {
                                                        DateTime parsedTime =
                                                            DateFormat.Hm()
                                                                .parse(timeFrom!
                                                                    .format(
                                                                        context)
                                                                    .toString());
                                                        String formattedTime =
                                                            DateFormat('h:mm a')
                                                                .format(
                                                                    parsedTime);

                                                        setState(() {
                                                          _selectedtimeFrom
                                                                  .text =
                                                              formattedTime;
                                                        });
                                                      } on FormatException catch (_, e) {
                                                        print(
                                                            "Error parsing timeFrom string: ${e.toString()}");
                                                      }
                                                    }
                                                  }),
                                            ),
                                            SizedBox(width: 16),
                                            Flexible(
                                              child: TextField(
                                                  controller: _selectedtimeTo,
                                                  style: TextStyle(
                                                      color: textColor),
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: textColor),
                                                    ),
                                                    icon: Icon(
                                                        Icons
                                                            .timelapse_outlined,
                                                        color: textColor),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              textColor), // Change this to your desired color
                                                    ),
                                                    labelText: "To",
                                                    labelStyle: TextStyle(
                                                        color: textColor),
                                                  ),
                                                  readOnly: true,
                                                  onTap: () async {
                                                    timeTo =
                                                        (await showTimePicker(
                                                      initialEntryMode:
                                                          TimePickerEntryMode
                                                              .dial,
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                      builder: (context,
                                                          Widget? child) {
                                                        return Theme(
                                                          data: ThemeData(
                                                            textButtonTheme:
                                                                TextButtonThemeData(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                foregroundColor:
                                                                    redColor, // Change this to your desired color
                                                              ),
                                                            ),
                                                            colorScheme:
                                                                ColorScheme
                                                                    .light(
                                                              primary:
                                                                  redColor, // Hour text color
                                                              onPrimary: Colors
                                                                  .white, // AM/PM text color
                                                            ),
                                                          ),
                                                          child: MediaQuery(
                                                            data: MediaQuery.of(
                                                                    context)
                                                                .copyWith(
                                                                    alwaysUse24HourFormat:
                                                                        false),
                                                            child: child!,
                                                          ),
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
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(grey9Button),
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
                                                vertical: 10, horizontal: 3),
                                            child: Text('Search',
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1)),
                                          ),
                                          onPressed: () {
                                            checkDateTimeAvailability(
                                                _selectedtimeFrom.text,
                                                _selectedtimeTo.text);
                                            calculateHours(_selectedtimeFrom.text, _selectedtimeTo.text);
                                          
                                          },
                                        ),
                                        if(noOfHours.text.isNotEmpty)
                                              Text("$hours hour/s",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w300,
                                                    color: textColor.withOpacity(0.8)))
                                              ,
                                        if (checkTable)
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(
                                                  "Available tables",
                                                  style: TextStyle(
                                                    color: greyColor6,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                      ]),
                                ),
                              ),
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 500),
                                top: controller.homeState == HomeState.normal
                                    ? 220
                                    : -(constraints.maxHeight - 100 * 2 - 85),
                                left: 0,
                                right: 0,
                                height: constraints.maxHeight - 230,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20 * 1.5),
                                      bottomRight: Radius.circular(20 * 1.5),
                                    ),
                                  ),
                                  child: GridView.builder(
                                    itemCount: _productList.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.8,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                    ),
                                    itemBuilder: (context, index) => TableCard(
                                        table: _productList[index],
                                        press: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: ((context) =>
                                          //             SingleTableScreen(
                                          //                 _productList[
                                          //                     index]))));
                                        }),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }),
              ),
            )));
  }

  Future<void> checkDateTimeAvailability(String timeFrom, String timeTo) async {
    ApiResponse response =
        await getTableDateTimeDetails(timeFrom, timeTo, _date.text);

    if (response.error == null) {
      if (response.data != null) {
        if (response.data == 500) {
          print("No Table available for Time and date available");
          setState(() {
            checkTable = false;
          });
        } else {
          print("Tables available");
          checkTable = true;
          setState(() {
            _productList = response.data as List<dynamic>;
            _loading = _loading ? !_loading : _loading;
          });
        }
      } else {
        showSnackBar(title: '', message: 'NO table is not available');
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
    noOfHours.text = hours.toString() ;
    //* widget.table.price).toString();
    // print('The difference between $timeString1 and $timeString2 is $hours hours and $minutes minutes');
  }
}
