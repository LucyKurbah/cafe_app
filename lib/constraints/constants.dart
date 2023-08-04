import 'package:cafe_app/components/colors.dart';
import 'package:flutter/material.dart';

const defaultPadding = 20.0;
const cartBarHeight = 100.0;
const headerHeight = 85.0;

const bgColor = Color(0xFFF6F5F2);
const primaryColor = Color(0xFF40A944);

const panelTransition = Duration(milliseconds: 500);
const Color grayColor = Color(0xFF8D8D8E);

InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.all(10),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: textColor)));
}

TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => blueColor),
        padding: MaterialStateProperty.resolveWith(
            (states) => const EdgeInsets.symmetric(vertical: 10))),
    child: Text(label, style: TextStyle(color: textColor)),
    onPressed: () => onPressed(),
  );
}

Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text(text),
    GestureDetector(
        onTap: (() => onTap()),
        child: Text(
          label,
          style: TextStyle(color: blueColor),
        ))
  ]);
}

Row kLoginForgotPasswordHint(String text, String label, Function onTap) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text(text),
    GestureDetector(
        onTap: (() => onTap()),
        child: Text(
          label,
          style: TextStyle(color: blueColor),
        ))
  ]);
}
