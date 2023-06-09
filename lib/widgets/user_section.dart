import 'package:flutter/material.dart';
import 'package:cafe_app/components/size_config.dart';

class UserSection extends StatelessWidget {
  IconData icon_name;
  String section_text;
UserSection({required this.icon_name, required this.section_text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          30,//SizeConfig.screenWidth!/13.7,          /// 30.0
          0,
          15,//SizeConfig.screenWidth!/27.4,          /// 15.0
          20,//SizeConfig.screenHeight!/34.15         /// 20.0
      ),
      child: Row(
        children: [
          Icon(icon_name, color: Colors.white,),
          SizedBox(width: 15), //SizeConfig.screenWidth!/41.1,),
          Text(section_text, style: TextStyle(color: Colors.white, fontSize:16 ),),//SizeConfig.screenHeight!/42.68),),      /// 16
          Spacer(),
          Icon(Icons.keyboard_arrow_right, color: Colors.white,size:32 ),//SizeConfig.screenHeight!/21.34,)                /// 32
        ],
      ),
    );
  }
}