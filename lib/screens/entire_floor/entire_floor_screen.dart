import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
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
import '../../services/entire_floor_service.dart';
import '../../services/user_service.dart';
import '../../widgets/custom_widgets.dart';
import '../add_on/addOn_page.dart';
import '../cart/cartscreen.dart';
import 'package:badges/badges.dart';
import 'package:intl/intl.dart';
import '../user/login.dart';

class EntireFloorScreen extends StatefulWidget {
  EntireFloorScreen({super.key});

  @override
  State<EntireFloorScreen> createState() => _EntireFloorScreenState();
}

class _EntireFloorScreenState extends State<EntireFloorScreen> {
  
  TextEditingController _date = TextEditingController();
  TextEditingController f_price = TextEditingController();

  int userId = 0;
  bool _loading = true;
  String t_date = '';
  String _cartMessage = '';
  bool checkTable = false;
  int f_id = 0;

  List<dynamic> _floorList = [].obs;

  String dropdownvalue = '0';   

  @override
  void initState(){
    super.initState();
    retrieveEntireFloor();
  }

  Future<void> retrieveEntireFloor() async{
    userId = await getUserId();
    ApiResponse response = await getEntireFloor();
    if(response.error == null){
      setState(() {
        _floorList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading; });
        print(_floorList);
    }
    else if(response.error == ApiConstants.unauthorized){
        logoutUser();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()),(route) => false);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }
   

  convertTimeToPostgres(bookDate){
    DateTime date = DateFormat('yyyy-MM-dd').parse(bookDate);
    DateTime postgresDateTime = DateTime(date.year, date.month, date.day);
    return postgresDateTime.toString();
  }

  Future<void> addCart(int floor_id , String date) async{
    if(floor_id == 0)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Choose a floor")));
    }
    userId = await getUserId();
    String bookDate =convertTimeToPostgres(date);
    ApiResponse response = await addEntireFloorToCart(floor_id, bookDate);
    
    if(response.error == null){
      if(response.data==200){
        setState(() {
            _cartMessage = "Added to Cart";
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${_cartMessage}"),duration: Duration(seconds: 1)));
            _loading = _loading ? !_loading : _loading;
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AddOnPage()), (route) => false);  });
      }
      else if(response.data=="X"){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selected Floor is not available for the selected date")));
      }
    }
    else if(response.error == ApiConstants.unauthorized){
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (context) => Login() ), (route) => false);
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
                    color: textColor,
                    child:  Hero(
                      tag: '',
                      child: Image.asset( "Assets/Images/cafe3.jpg",fit: BoxFit.fill),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height *0.3),
                    height: size.height ,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                    ),
                    child:               
                    Padding(
                          padding: EdgeInsets.only(left: 25, right: 40, top: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                              "Book an Entire floor",
                                style: TextStyle(fontSize: 30,letterSpacing: 1,color: textColor),
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
                              // SizedBox(height: 20),
                              //  Text(_floorList.isNotEmpty?"PRICE: Rs. ${_floorList[0].price} /hr":"",
                              //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color : textColor)
                              //       ),

                              SizedBox(height: 30,),
                              Container(
                              height: 110,
                              child: Column(
                                children: [
                                  Flexible(
                                    child: DropdownButton<String>(
                                         value: dropdownvalue,
                                            icon: const Icon(Icons.keyboard_arrow_down),    
                                            items:[ 
                                              DropdownMenuItem<String>(
                                                    value: "0",
                                                    child: Text("Select a floor"),
                                                  ),
                                                  ..._floorList.map((floor) {
                                                  return DropdownMenuItem<String>(
                                                    value: floor.id.toString(),
                                                    child: Text(floor.floor_name),
                                                  );
                                                }).toList(),
                                            ],
                                            onChanged: (String? newValue)  { 
                                              print(newValue);
                                              setState(() {
                                                dropdownvalue = newValue!;
                                                 if (newValue == "0") {
                                                  // Handle the case when "Select item" is chosen
                                                  f_price.text = ""; // Set the price field to empty or any other default value
                                                  f_id = 0; // Set the floor ID to null or any other default value
                                                } else {
                                                  for (var floor in _floorList) {
                                                    if(floor.id.toString() == newValue)
                                                    {
                                                        f_price.text = floor.price.toString();
                                                        f_id = floor.id;
                                                    }
                                                  }
                                                }
                                              });
                                            },
                                            style: TextStyle(color: textColor),
                                              dropdownColor: Colors.grey[700],
                                              underline: Container(height: 1,color: textColor,),
                                              isExpanded: true,
                                              hint: Text(dropdownvalue ?? 'Select a floor',
                                                style: TextStyle(color: textColor),
                                              ),
                                    )
                                  ),
                                  Flexible(
                                    child: TextField(
                                      controller: _date,
                                      style: TextStyle(color: textColor),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: textColor),
                                        ),
                                        suffixIcon: Icon(Icons.calendar_month_sharp,
                                            color: textColor),
                                        labelText: "Select Date",
                                        labelStyle:
                                            TextStyle(color: textColor),
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
                                            checkDateTimeAvailability(dropdownvalue); 
                                            
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 1,),
                         
                          f_price.text.isNotEmpty ?Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("TOTAL PRICE: Rs." + f_price.text,
                                          style: TextStyle(
                                              fontSize: Dimensions.font20,
                                              fontWeight: FontWeight.w400,
                                              color: textColor))
                                              ],
                                            ),
                                          )
                                    : SizedBox.shrink(),
                              SizedBox(height:10),
                              checkTable?Center(
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
                                                            child: Text('Add to Cart', style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                                          ),
                                                          onPressed:  (){
                                                            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => CartScreen()));
                                                             addCart(f_id, t_date);
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
                                                              child: Text('Add to Cart', style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
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
  
  buildAppBar(context) {
    return AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
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

  void checkDateTimeAvailability(floor_id)  async {

    ApiResponse response = await checkFloorDetails(floor_id, _date.text);
   print(response.data == '500');
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
            print("Date available");
            setState(() {
               checkTable=true;
            });
        }
        else if(response.data=="X")
        {
            print("Date not available");
            showSnackBar(title: '',message: 'The Date is not available');
            setState(() {
               checkTable=false;
            });
        }
        else if(response.data =='500')
        {
            print("Date not available");
            showSnackBar(title: '',message: 'The Date is not available');
            setState(() {
               checkTable=false;
            });
        }
      }
      else{
        showSnackBar(title: '',message: 'The Date is not available');
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


