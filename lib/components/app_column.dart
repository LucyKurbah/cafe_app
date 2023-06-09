import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../widgets/custom_widgets.dart';
import 'colors.dart';
import 'dimensions.dart';

class AppColumn extends StatelessWidget {
  const AppColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      BigText("Event 1",textColor),
                      SizedBox(height: Dimensions.height10,),
                      Row(
                        children: [
                          Wrap(
                            children: List.generate(5, (index) => Icon(Icons.star, color: textColor,size: 15,)),
                          ),
                          SizedBox(width: Dimensions.width10,),
                          SmallText("text", textColor),
                          SizedBox(width: Dimensions.width10,),
                          SmallText("1245", textColor),
                        ],
                      ),
                      SizedBox(height: Dimensions.height20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            IconText(Icons.circle_sharp, iconColors1, "Normal", textColor),
                            
                            IconText(Icons.location_on, iconColors3, "Location", textColor),
                            
                            IconText(Icons.access_time_rounded, iconColors2, "Normal", textColor ),
                        ],
                      ),
                      
                ]);
  }
}