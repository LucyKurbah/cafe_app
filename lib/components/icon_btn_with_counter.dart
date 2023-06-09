import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class IconBtnWithCounter extends StatelessWidget {
  const IconBtnWithCounter({
    Key? key, required this.svgSrc, this.numOfItems=0, required this.press,
  }) : super(key: key);

  final String svgSrc;
  final int numOfItems;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
     onTap: 
        press,
    
     
     borderRadius: BorderRadius.circular(50),
      child: Stack(
         
           children:[ 
             SizedBox(height: 20,),
             Container(
                 padding: EdgeInsets.all(10),
                 margin: EdgeInsets.only(right: 20),
                 height: 46,
                 width: 46,
                 decoration: BoxDecoration(
                   color: Colors.grey.withOpacity(0.5),
                   shape: BoxShape.circle,
                 ),
                 child: SvgPicture.asset(svgSrc)
             ),

             if(numOfItems != 0)
             Positioned(
               right: 0,
               
               child: Container(
                     height: 13,
                     width: 13,
                     margin: EdgeInsets.only(right: 20),
                     decoration: BoxDecoration(
                       color: Color(0xffff4848),
                       shape: BoxShape.circle,
                       border: Border.all(width: 1.5, color: Colors.white)
                     ),
                     child: 
                       Center(
                         child: Text('$numOfItems', 
                           style: TextStyle(
                             fontSize: 10, 
                             height: 1, 
                             color: Colors.white,
                             fontWeight: FontWeight.w600
                             ),
                           ),
                       )
               ),
               
             )
           ]
       ),
    );
  }
}