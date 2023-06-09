
import 'package:cafe_app/models/AddOn.dart';
import 'package:flutter/material.dart';
import '../../api/apiFile.dart';
import '../../components/colors.dart';
import '../../components/dimensions.dart';
import '../../constraints/constants.dart';
import '../../models/Event.dart';
import '../../services/api_response.dart';
import '../../services/event_service.dart';
import '../../widgets/custom_widgets.dart';


class EventCard extends StatelessWidget {

  EventCard({
    Key? key,
    required this.event,
    required this.matrix
  }) : super(key: key);

  final Event event;
  final Matrix4 matrix;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;

  // Future<void> addCart(AddOn item) async{
  @override
  Widget build(BuildContext context) {
   

  return Transform(
    transform: matrix,
    child: Stack(
      children: [
        Container(
            height: Dimensions.pageViewContainer+20,
            margin: EdgeInsets.only(left: Dimensions.width5, right: Dimensions.width5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              color: Color.fromARGB(255, 136, 142, 143),
              image: DecorationImage(
                image: NetworkImage(
                                  "${this.event.image}",//_eventsList[index]['image'],
                                  // fit: BoxFit.contain,
                                  scale: 0.4,
                                )
                // fit: BoxFit.cover
              )
            ),
            // child: Image.network(
            //                       "${_eventsList[index].image}",
            //                       fit: BoxFit.contain,
            //                       // scale: 0.4,
            //                     ),
        ),
        // Align(
        //   alignment: Alignment.center,
        //   child: Container(
        //       height: Dimensions.pageViewTextContainer,
        //       margin: EdgeInsets.only(top:Dimensions.width120,left: Dimensions.width60, right: Dimensions.width60, bottom: Dimensions.width30),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(Dimensions.radius20),
        //         color: textColor,
        //       ),
        //       child: Container(
        //         padding: EdgeInsets.only(top: Dimensions.height15, left: Dimensions.height15, right: Dimensions.height15),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //               BigText("${this.event.slider_name}",mainColor),
        //               SizedBox(height: Dimensions.height10,),
        //               Row(
        //                 children: [
        //                   Wrap(
        //                     children: List.generate(5, (index) => Icon(Icons.star, color: mainColor,size: 15,)),
        //                   ),
        //                   SizedBox(width: Dimensions.width10,),
        //                   SmallText("text", mainColor),
        //                   SizedBox(width: Dimensions.width10,),
        //                   SmallText("1245", mainColor),
        //                 ],
        //               ),
        //               SizedBox(height: Dimensions.height20,),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                     IconText(Icons.circle_sharp, iconColors1, "Name", mainColor),
                            
        //                     IconText(Icons.location_on, iconColors3, "Location", mainColor),
                            
        //                     IconText(Icons.access_time_rounded, iconColors2, "Time", mainColor ),
        //                 ],
        //               )
        //         ]),
        //       ),
        //   ),
        // ),
      ]
    ),
  );
      
  }
}

