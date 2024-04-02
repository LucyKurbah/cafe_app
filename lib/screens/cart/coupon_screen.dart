import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/screens/cart/cartscreen.dart';
import 'package:flutter/material.dart';

import '../../api/apiFile.dart';
import '../../models/Coupon.dart';
import '../../services/api_response.dart';
import '../../services/cart_service.dart';
import '../../screens/cart/coupon_card.dart';

class CouponScreen extends StatefulWidget {
  @override
  _CouponScreenState createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {

  List<dynamic> _couponList  = [];
  bool _isLoading = true;

   @override
  void initState() {
     Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = true;
        retrieveCoupons();
        // retrieveTableCart();
      });
    });
    super.initState();
  }

   Future<void> retrieveCoupons() async {
    ApiResponse response = await retrieveAllCoupons();
    if (response.error == null) {
      setState(() {
        _couponList = List<Coupon>.from(response.data as List<dynamic>);
        _isLoading = _isLoading ? !_isLoading : _isLoading;
      });
    } else if (response.error == ApiConstants.unauthorized) {
        print(response.error);
    } else {
        print(response.error);
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Text('Available Coupons'),
        backgroundColor: mainColor,
      ),
      body: ListView.builder(
        itemCount: _couponList.length,
        itemBuilder: (context, index) {
         
          return CouponCard(
            coupon: _couponList[index],
            applyCoupon: () {
               applyCoupon(
                  _couponList[index]);
            },
          );
        },
      ),
    );
  }

   Future<void> applyCoupon(Coupon coupon) async {
    ApiResponse response = await addCouponToCart(coupon);
    if (response.error == null) {
      setState(() {
        _isLoading = true;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Coupon Applied'),
              content: Text('The coupon has been successfully applied.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Navigator.pop(context); // Close the dialog
                    // Navigator.pop(context); // Close the CouponScreen
                    
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                      (route) => false);
                              },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
    } 
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${response.error}"),
          duration: const Duration(seconds: 1)));
    }
  }

//  Future<void> applyCoupon(Coupon coupon) async {
//       setState(() {
//         _isLoading = true;
//       });

//        // Assuming you have a function to apply the coupon to the cart total
//       // Replace applyCouponToTotal with your actual function
      
//       bool couponApplied = await applyCouponToTotal(coupon);

//       setState(() {
//         _isLoading = false;
//       });

//       if (couponApplied) {
//         // Show a pop-up indicating the coupon has been applied
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Coupon Applied'),
//               content: Text('The coupon has been successfully applied.'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Close the dialog
//                     Navigator.pop(context); // Close the CouponScreen
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         // Show an error message if the coupon could not be applied
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Coupon Error'),
//               content: Text('Failed to apply the coupon. Please try again later.'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Close the dialog
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       }
// }

}


// class CouponCard extends StatelessWidget {
//   final String coupon;

//   const CouponCard({Key? key, required this.coupon}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CouponCard(coupon: coupon);
//   }
// }
