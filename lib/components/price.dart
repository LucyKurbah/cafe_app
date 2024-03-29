import 'package:cafe_app/components/colors.dart';
import 'package:flutter/material.dart';

import '../constraints/constants.dart';

class Price extends StatelessWidget {
  const Price({
    Key? key,
    required this.amount,
  }) : super(key: key);
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: " ₹ ",
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.w600, color: primaryColor),
        children: [
          TextSpan(
            text: amount,
            style: TextStyle(color: textColor),
          ),
         
        ],
      ),
    );
  }
}
