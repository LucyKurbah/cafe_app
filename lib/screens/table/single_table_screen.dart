import 'package:cafe_app/constraints/constants.dart';
import 'package:cafe_app/screens/table/datetime_screen.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/models/Table.dart';
import 'package:cafe_app/controllers/home_controller.dart';
import 'package:provider/provider.dart';
import '../../api/apiFile.dart';
import '../../components/badge_widget.dart';
import '../../services/api_response.dart';
import '../../services/user_service.dart';
import '../cart/cartscreen.dart';
import 'package:badges/badges.dart';

import '../home/home.dart';
import '../user/login.dart';

class SingleTableScreen extends StatelessWidget {
  SingleTableScreen(this.table, {super.key});
  
  TableModel table;
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
                      tag: '${table.id}',
                      child: Image.network(
                                   table.image,
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
                              table.table_name,
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
                              SizedBox(height: 30,),

                              Text("No of seats: ${table.table_seats}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight : FontWeight.w500,
                                    color: Colors.white.withOpacity(0.8)
                                  )
                              ),
                              SizedBox(height: 30),
                              Text("PRICE: Rs. ${table.price}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color : Colors.white  
                                      )),

                              SizedBox(height: 100,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                            
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 50, 54, 56),
                                        borderRadius: BorderRadius.circular(18)
                                      ),
                                     
                                      child:
                                              TextButton(
                                                      child: Text('Book Table', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                                      onPressed:  (){
                                                        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => CartScreen()));
                                                        _loadUserInfo(context);
                                                        }
                                                      )
                                    ),
                                    
                                    
                                  ],
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
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>DateTimeScreen(table)));
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

// void _showTimePicker(context)
// {
//   showTimePicker(
//     context: context, 
//     initialTime: TimeOfDay.now(),
//   );
// }
  
}