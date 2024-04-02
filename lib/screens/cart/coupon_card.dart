import 'package:cafe_app/components/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/Coupon.dart';

class CouponCard extends StatelessWidget {

  final Coupon coupon;
   final VoidCallback applyCoupon;
  const CouponCard({Key? key,required this.coupon,  required this.applyCoupon,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: greyColor,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: ListTile(
        title: Text(coupon.coupon_name, style: TextStyle(fontWeight: FontWeight.w900),),
        subtitle: Text('Amount: ₹${coupon.amount.toStringAsFixed(2)}'),
        trailing: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(tealColor), // Set the background color
            ),
          onPressed: applyCoupon,
          child: Text('APPLY'),
        ),
      ),
    );
  }
}
