import 'package:cafe_app/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import '../../../constraints/constants.dart';

class CardShortView extends StatelessWidget {
  const CardShortView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child:  Icon(Icons.shopping_cart,color: Color(0xffe57734),size: 27,)
        ),
          IconButton(
            onPressed: (){},
            icon:
              Image.asset('Assets/icons/arrow-up.png',height: 20,),
              
          ),
        const SizedBox(width: defaultPadding),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                controller.cart.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: defaultPadding / 2),
                  child: Hero(
                    tag: "${controller.cart[index].product.title}_cartTag",
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:
                          NetworkImage(controller.cart[index].product.image),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Text(
            controller.totalCartItems().toString(),
            style: TextStyle(fontWeight: FontWeight.bold, color:  Color(0xffe57734)),
          ),
          // Icon(Icons.circle_outlined,color: Color(0xffe57734),size: 27,),
        )
      ],
    );
  }
}
