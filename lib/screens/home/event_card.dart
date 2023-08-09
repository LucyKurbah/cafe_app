import 'package:cafe_app/components/colors.dart';
import 'package:flutter/material.dart';
import '../../components/dimensions.dart';
import '../../models/Event.dart';

class EventCard extends StatelessWidget {
  const EventCard({Key? key, required this.event, required this.matrix})
      : super(key: key);

  final Event event;
  final Matrix4 matrix;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: matrix,
      child: Stack(children: [
        Container(
          height: Dimensions.pageViewContainer + 20,
          margin: EdgeInsets.only(
              left: Dimensions.width5, right: Dimensions.width5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              color: lightBlueGrey,
              image: DecorationImage(
                  image: 
                  NetworkImage(
                    event.image, //_eventsList[index]['image'],
                    // fit: BoxFit.contain,
                    scale: 0.9,
                  ), 
                  fit: BoxFit.fill
                  )),
        ),
      ]),
    );
  }
}
