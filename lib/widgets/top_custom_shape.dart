import 'package:cafe_app/models/ProfileModel.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/size_config.dart';
import 'package:cafe_app/components/custom_shape.dart';

class TopCustomShape extends StatefulWidget {
  TopCustomShape({Key? key, required this.profileInfo,}) : super(key: key);

  ProfileModel profileInfo;

  @override
  _TopCustomShapeState createState() => _TopCustomShapeState();
}

class _TopCustomShapeState extends State<TopCustomShape> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,//SizeConfig.screenHeight,               /// 240.0
      child: Stack(
        children: [
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: 150,//SizeConfig.screenHeight!/4.56,       /// 150.0
              color: Colors.black,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 140.0,
                  width: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 0.0),
                    color: Colors.white,
                  ),
                  child: Image.asset(
                    "Assets/Images/user.png",
                    fit: BoxFit.cover,
                    
                  ),
                ),
                Text("${widget.profileInfo.name}", style: TextStyle(fontSize: 22,color: Colors.white),),
                SizedBox(height: 5,),//SizeConfig.screenHeight!/136.6,),              /// 5.0
                Text("${widget.profileInfo.email}", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
