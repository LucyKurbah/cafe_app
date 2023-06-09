import 'package:flutter/material.dart';

const defaultPadding = 20.0;
const cartBarHeight = 100.0;
const headerHeight = 85.0;

const bgColor = Color(0xFFF6F5F2);
const primaryColor = Color(0xFF40A944);

const panelTransition = Duration(milliseconds: 500);
const Color grayColor = Color(0xFF8D8D8E);



InputDecoration kInputDecoration(String label){
   return InputDecoration(
                labelText: label,
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.white))
              );
}

TextButton kTextButton(String label, Function onPressed){
  return TextButton(
             
      style: ButtonStyle(
                 backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                 padding: MaterialStateProperty.resolveWith((states) =>   EdgeInsets.symmetric(vertical: 10))
              ),
      child: Text(label, style: TextStyle(color: Colors.white)),
       onPressed: () => onPressed(),
      );
             
}


Row kLoginRegisterHint(String text, String label, Function onTap)
{
  return  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text),
                GestureDetector(
                        child: Text(label, style: TextStyle(color: Colors.blue),),
                        onTap: (() => onTap()
                      ))
              ]
  );
}

Row kLoginForgotPasswordHint(String text, String label, Function onTap)
{
  return  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text),
                GestureDetector(
                        child: Text(label, style: TextStyle(color: Colors.blue),),
                        onTap: (() => onTap()
                      ))
              ]
  );
}