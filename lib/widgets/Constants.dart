import 'package:flutter/material.dart';

class Constants {
  //Server Configuration
  static const String baseUrl = 'http://10.0.2.2:8020/api/'; //Emulator
  //static const String baseUrl = 'http://192.168.29.17:8080/api/'; //Mobile
  //static const String baseUrl = 'http://127.0.0.1:8080/api/'; //Localhost / We

  //App Configuration
  static const bool kDebugMode = true;

  //Colors
  static const Color colorPrimary = Color(0xff4A80F0);
  static const Color colorInfo = Color(0xff89bfe7);
  static const Color colorDanger = Color(0xffc72c41);
  static const Color colorSuccess = Color(0x0000ffff);
  static const Color colorWarning = Color(0xffFCA652);
  static const Color colorLight = Color(0xFFFDFDFD);
  static const Color colorDark = Color(0xFF111111);

  static const Color colorBackground = Color(0xff121421);
  static const colorPrimaryDark = Color(0xff1C2031);
  static const colorGrey = Color(0xff515979);
  static const colorPurple = Color(0xff4A80F0);

  static const List<List<Color>> gradientList = [
    [Color(0xFF111111), Color(0xff1C2031)],
    [Color(0xFF111111), Color(0xff4A80F0)],
    [Color(0xFF111111), Color(0xFF4CB051)],
    [Color(0xFF111111), Color(0xffc72c41)],
    [Color(0xFF111111), Color(0xffFCA652)],
    [Color(0xFF111111), Color(0xff515979)],
    [Color(0xFF111111), Color(0xff1C2031)],
    [Color(0xFF111111), Color(0xff4A80F0)],
    [Color(0xFF111111), Color(0xFF4C8051)],
    [Color(0xFF111111), Color(0xffa72c41)],
    [Color(0xFF111111), Color(0xffFC6252)],
  ];

  static const Widget horizontalSpace = SizedBox(width: 5.0);
  static const Widget horizontalSpaceM = SizedBox(width: 10.0);
  static const Widget horizontalSpaceL = SizedBox(width: 18.0);
  static const Widget horizontalSpaceXL = SizedBox(width: 28.0);
  static const Widget horizontalSpaceXXL = SizedBox(width: 50.0);

  static const Widget verticalSpaceS = SizedBox(height: 2.0);
  static const Widget verticalSpace = SizedBox(height: 10.0);
  static const Widget verticalSpaceM = SizedBox(height: 16.0);
  static const Widget verticalSpaceL = SizedBox(height: 25);
  static const Widget verticalSpaceXL = SizedBox(height: 50.0);
  static const Widget verticalSpaceXXL = SizedBox(height: 120.0);
}
