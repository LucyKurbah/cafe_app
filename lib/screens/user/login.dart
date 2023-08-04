import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:cafe_app/controllers/login_controller.dart';
import 'package:cafe_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/constraints/constants.dart';
import 'package:get/get.dart';
import 'forgotPassword.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  LoginController loginController = Get.put(LoginController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
       Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          mainColor,
          // mainColor,
          greyColor
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(
              height: Dimensions.height20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: IconButton(
            onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                                      builder: (context) => const HomeScreen()
                                                                ), 
                                                (route) => false);
            }, 
            icon: const Icon(Icons.arrow_back), color: textColor,)
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/100,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(color: textColor, fontSize: 40),
                  ),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                ],
              ),
            ),
            Expanded(
                child: Form(
              key: formKey,
              child: Container(
                decoration: BoxDecoration(
                    color: textColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: textColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow:  [
                              BoxShadow(
                                  color: greyColor,
                                  blurRadius: 20,
                                  offset: const Offset(0, 10))
                            ]),
                        child: Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration:  BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: greyColor))),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: loginController.txtEmail,
                                  style: const TextStyle(fontSize: 18.0),
                                  validator: (value) => value!.isEmpty
                                      ? 'Invalid Email Address'
                                      : null,
                                  decoration:  InputDecoration(
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: greyColor),
                                      border: InputBorder.none),
                                )),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration:  BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: greyColor))),
                              child: TextFormField(
                                obscureText: _obscureText,
                                controller: loginController.txtPassword,
                                style: const TextStyle(fontSize: 18.0),
                                validator: (value) => value!.length < 6
                                    ? 'Required at least 6 characters'
                                    : null,
                                decoration: InputDecoration(
                                   suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText ? Icons.visibility_off : Icons.visibility,color: mainColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                    hintText: "Password",
                                    hintStyle:  TextStyle(color: greyColor),
                                    border: InputBorder.none),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      kLoginRegisterHint('Dont have an account? ', 'Register',
                          () {
                       
                        Get.to(const Register(), transition: Transition.rightToLeftWithFade);
                      }),
                       SizedBox(
                        height: Dimensions.height20,
                      ),
                      kLoginForgotPasswordHint('', 'Forgot Password?',
                          () {
                       
                        Get.to(const ForgotPassword(), transition: Transition.rightToLeftWithFade);
                      }),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                      loginController.loginUser();
                                       
                                    });
                                  }
                        },
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: greyColor7,
                              boxShadow: [
                                BoxShadow(
                                  color: greyColor.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset:
                                      const Offset(0, 3), // changes position of shadow
                                ),
                              ]),
                          child: Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Center(
                        child: Text("Or"),
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      Center(
                        child: buildLoginButton(),
                      )
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }


  FloatingActionButton buildLoginButton() {
    return FloatingActionButton.extended(
      onPressed: loginController.loginUser,
      label: const Text("Sign in with Google"),
      foregroundColor: mainColor,
      backgroundColor: textColor,
      icon: Image.asset(
        'Assets/Images/google_logo.png',
        height: 32,
        width: 32,
      ),
    );
  }
}
