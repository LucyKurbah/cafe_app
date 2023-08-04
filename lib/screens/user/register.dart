import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/controllers/register_controller.dart';
import '../../constraints/constants.dart';
import 'login.dart';
import 'package:get/get.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  RegisterController registerController = Get.put(RegisterController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(

        child: Container(
           height: MediaQuery.of(context).size.height,
          decoration:  BoxDecoration(
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
              Navigator.of(context).pop();
            }, 
            icon: const Icon(Icons.arrow_back), color: textColor,)
            ),
            const SizedBox(
              height: 100,
            ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
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
                       mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        Container(
                          padding:const  EdgeInsets.all(20),
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
                                    controller: registerController.nameController,
                                    validator: (value) =>
                                        value!.isEmpty ? 'Invalid Name' : null,
                                    style: const TextStyle(fontSize: 18.0),
                                    decoration:  InputDecoration(
                                        hintText: "Name",
                                        hintStyle: TextStyle(color: greyColor),
                                        border: InputBorder.none),
                                  )),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration:  BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: greyColor))),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller:
                                        registerController.emailController,
                                    validator: (value) => value!.isEmpty
                                        ? 'Invalid Email Address'
                                        : null,
                                    style: const TextStyle(fontSize: 18.0),
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
                                  obscureText: true,
                                  controller:
                                      registerController.passwordController,
                                  style: const TextStyle(fontSize: 18.0),
                                  validator: (value) => value!.length < 6
                                      ? 'Required at least 6 characters'
                                      : null,
                                  decoration:  InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: greyColor),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration:  BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: greyColor))),
                                child: TextFormField(
                                  obscureText: true,
                                  controller: registerController
                                      .passwordConfirmController,
                                  style: TextStyle(fontSize: 18.0),
                                  validator: (value) => value !=
                                          registerController
                                              .passwordConfirmController.text
                                      ? 'Confirm password does not match'
                                      : null,
                                  decoration:  InputDecoration(
                                      hintText: "Confirm Password",
                                      hintStyle: TextStyle(color: greyColor),
                                      border: InputBorder.none),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        kLoginRegisterHint('Already have an account? ', 'Login',
                            () {
                          Get.to(const Login(),
                              transition: Transition.rightToLeftWithFade);
                        }),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
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
                            child: 
                            
                            loading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : TextButton(
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = !loading;
                                      registerController.registerUser();
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

  ListView buildRegister(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      children: [
        TextFormField(
          controller: registerController.nameController,
          validator: (value) => value!.isEmpty ? 'Invalid Name' : null,
          decoration: kInputDecoration('Name'),
        ),
        SizedBox(height: Dimensions.height10),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: registerController.emailController,
          validator: (value) => value!.isEmpty ? 'Invalid Email Address' : null,
          decoration: kInputDecoration('Email'),
        ),
        SizedBox(height:Dimensions.height10),
        TextFormField(
          obscureText: true,
          controller: registerController.passwordController,
          validator: (value) =>
              value!.length < 6 ? 'Required at least 6 characters' : null,
          decoration: kInputDecoration('Password'),
        ),
        SizedBox(height: Dimensions.height10),
        TextFormField(
          obscureText: true,
          controller: registerController.passwordConfirmController,
          validator: (value) =>
              value != registerController.passwordController.text
                  ? 'Confirm password does not match'
                  : null,
          decoration: kInputDecoration('Confirm Password'),
        ),
        SizedBox(height: Dimensions.height10),
        loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : kTextButton('Register', () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    loading = !loading;
                    registerController.registerUser();
                  });
                }
              }),
        SizedBox(
          height: Dimensions.height10,
        ),
        kLoginRegisterHint('Already have an account? ', 'Login', () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false);
        })
      ],
    );
  }
}
