import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/main.dart';
import 'package:flutter/material.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  List<Widget> noList = [];
  var count =0;
  final columnCount=2;
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text("data", 
        style: TextStyle(color: mainColor,fontSize: 24)),
      ),
    );
  }
}