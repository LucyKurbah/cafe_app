
import 'package:cafe_app/components/colors.dart';
import 'package:flutter/material.dart';


class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Settings Page", style: TextStyle(color: textColor, fontSize: 18)));
  }
}