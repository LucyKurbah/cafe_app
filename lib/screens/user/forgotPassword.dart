
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/controllers/forgotPassword_controller.dart';
import '../../constraints/constants.dart';
import 'login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
 ForgotPasswordController forgotPasswordController = Get.put(ForgotPasswordController());
 final GlobalKey<FormState> formKey = GlobalKey<FormState>();
bool loading = false;

  @override
  Widget build(BuildContext context) {
 return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(

        child: Container(
           height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.black,
            // Colors.black,
            Colors.grey
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            }, 
            icon: Icon(Icons.arrow_back), color: Colors.white,)
            ),
            SizedBox(
              height: 100,
            ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reset Password",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Form(
                key: formKey,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                       mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: [
                             
                              Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey))),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller:
                                         forgotPasswordController.emailController,
                                    validator: (value) => value!.isEmpty
                                        ? 'Invalid Email Address'
                                        : null,
                                    style: TextStyle(fontSize: 18.0),
                                    decoration: InputDecoration(
                                        hintText: "Email",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  )),
                              
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        kLoginRegisterHint('Already have an account? ', 'Login',
                            () {
                          Get.to(Login(),
                              transition: Transition.rightToLeftWithFade);
                        }),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[700],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset:
                                      Offset(0, 3), // changes position of shadow
                                ),
                              ]),
                          child: Center(
                            child: 
                            
                            loading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : TextButton(
                                child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = loading;
                                      forgotPasswordController.forgotUserPassword();

                                    });
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );

  }
}