import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:cafe_app/constraints/constants.dart';
import 'package:cafe_app/screens/table/datetime_screen.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/models/Table.dart';
import 'package:get/get.dart';
import '../../api/apiFile.dart';
import '../../components/badge_widget.dart';
import '../../services/api_response.dart';
import '../../services/user_service.dart';
import '../../widgets/AlertBox.dart';
import '../user/login.dart';

class SingleTableScreen extends StatelessWidget {
  SingleTableScreen(this.table, {super.key});

  TableModel table;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: mainColor,
      extendBodyBehindAppBar: true,
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
                    height: size.height * 0.7,
                    color: textColor,
                    child: Image.network(table.image, fit: BoxFit.fill),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: size.height * 0.6),
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
                              table.table_name,
                              style: TextStyle(
                                  fontSize: 30,
                                  letterSpacing: 1,
                                  color: textColor),
                            ),
                            SizedBox(
                              height: Dimensions.height10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: greyColor6,
                                  size: 20,
                                ),
                                Icon(Icons.star,
                                    color: greyColor6, size: 20),
                                Icon(Icons.star,
                                    color: greyColor6, size: 20),
                                Icon(Icons.star,
                                    color: greyColor6, size: 20),
                                Icon(Icons.star,
                                    color: greyColor6, size: 20),
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.height20,
                            ),
                            Text("Rs. ${table.price}",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: textColor)),
                            Text(
                              "inclusive of all taxes",
                              style: TextStyle(color: greyColor),
                            ),
                            SizedBox(height: Dimensions.height20),
                            Text("${table.table_seats} seats",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: textColor.withOpacity(0.8))),
                            SizedBox(
                              height: Dimensions.height45,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                          color:
                                              grey9Button,
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      child: TextButton(
                                          child: Text('Book Table',
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1)),
                                          onPressed: () {
                                            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => CartScreen()));
                                            _loadUserInfo(context);
                                          })),
                                ],
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
      backgroundColor: transparentColor,
      actions:const  [
        Padding(
          padding:  EdgeInsets.only(
              right: defaultPadding, left: defaultPadding),
          child: Center(
            child: BadgeWidget(),
          ),
        )
      ],
    );
  }

  void _loadUserInfo(context) async {
    String token = await getToken();

    if (token == '' || token == null) {
      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false);
      AlertBox(
          title: 'Alert',
          message: 'You need to Login/ Register before booking',
          buttonTextForYes: "Login",
          onPressedYes: () => Get.to(() => const Login()));
    } else {
      ApiResponse response = await getUserDetails();
      print(response.data);
      if (response.error == null) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DateTimeScreen(table)));
      } else if (response.error == ApiConstants.unauthorized) {
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>Login()), (route) => false);
        AlertBox(
            title: 'Alert',
            message: 'You need to Login/ Register before booking',
            buttonTextForYes: "Login",
            onPressedYes: () => Get.to(() => const Login()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    }
  }

}
