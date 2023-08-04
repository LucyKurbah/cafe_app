import 'package:cafe_app/components/colors.dart';
import 'package:flutter/material.dart';
import '../../../constraints/constants.dart';
import '../../../models/Cart.dart';

class CartDetailsViewCard extends StatelessWidget {
  const CartDetailsViewCard({
    Key? key,
    required this.productItem,
  }) : super(key: key);

  final Cart productItem;

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: textColor,
            backgroundImage: NetworkImage(productItem.image),
          ),
          title: Text(
            productItem.item_name,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold, color: textColor),
          ),
          trailing: FittedBox(
            child: Row(
              children: [
                // const Price(amount: "20"),
                
                Text("₹ ${productItem.item_price}",style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold, color: textColor),
                ),
                Text(
                  "  x  ${productItem.quantity}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold, color: textColor),
                ),
                Text(
                  " = ${productItem.item_price * productItem.quantity}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold, color: textColor),
                )
                
              ],
            ),
            
          ),
          
        ),
      ],
    );
    
  }
}
