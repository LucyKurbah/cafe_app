import 'package:cafe_app/constraints/constants.dart';
import 'package:cafe_app/controllers/home_controller.dart';
import 'package:flutter/material.dart';

class CartDetailsView extends StatelessWidget {
  const CartDetailsView({Key? key, required this.controller}) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          Text("Cart", style: Theme.of(context).textTheme.titleLarge),
          // ...List.generate(
          //   controller.cart.length,
          //   (index) => CartDetailsViewCard(productItem: controller.cart[index]),
          // ),
          const SizedBox(height: defaultPadding),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Next - \$30"),
            ),
          )
        ],
      ),
    );
  }
}
