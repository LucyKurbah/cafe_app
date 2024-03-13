import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:cafe_app/models/AddOn.dart';
import 'package:flutter/material.dart';
import '../../constraints/constants.dart';

class AddOnCard extends StatelessWidget {
  AddOnCard({
    Key? key,
    required this.product,
    required this.addItem,
    required this.removeItem,
    required this.press,
  }) : super(key: key);

  final AddOn product;
  final VoidCallback addItem, removeItem, press;
  bool rememberMe = false;
  bool checkedValue = false;
  int userId = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      decoration: BoxDecoration(
        color: greyColor9,
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding * 1.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 20),
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                product.image,
                fit: BoxFit.fill,
                scale: 0.4,
              )),
          SizedBox(height: Dimensions.height20,),
          Text(
            product.title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600, fontSize: 18, color: textColor),
          ),
          Text(
               product.desc,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: textColor),
            ),
          SizedBox(
            height: Dimensions.height20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹ ${product.price}",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600, color: textColor),
              ),
              
              Container(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: redColor),
                child: 
                // product.quantity == null || product.quantity == 0    
                //     ? 
                    InkWell(
                        onTap: addItem,
                        child: Text("Add",style: TextStyle(color: textColor, fontSize: 12),),
                      )
                    // : 
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       GestureDetector(
                    //           onTap: removeItem,
                    //           child: Text("- ",
                    //               style: TextStyle(
                    //                   color: textColor,
                    //                   fontSize: 25,
                    //                   fontWeight: FontWeight.bold))),
                    //       SizedBox(width: Dimensions.width10),
                    //       Text(
                    //         "${product.id}",
                    //         style: TextStyle(
                    //             fontSize: Dimensions.font17, color: textColor),
                    //       ),
                    //       SizedBox(width: Dimensions.width10),
                    //       GestureDetector(
                    //         onTap: addItem,
                    //         child: Icon(Icons.add, color: textColor),
                    //       ),
                    //     ],
                    //   ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
