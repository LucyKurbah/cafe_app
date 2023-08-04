

import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/fav_btn.dart';
import 'package:cafe_app/models/Product.dart';
import 'package:flutter/material.dart';
import '../../../constraints/constants.dart';

class ProductCard extends StatelessWidget {


  const ProductCard({
    Key? key,
    required this.product,
     required this.addItem,
    required this.removeItem,
    required this.press,
  }) : super(key: key);

  final Product product;

  final VoidCallback press,addItem, removeItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
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
            InkWell(
                      onTap: () {
                        
                      },
                      child: 
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child:
                              Image.network(
                                 product.image,
                                  fit: BoxFit.contain,
                                  scale: 0.4,
                                )
                             
                      ),
              ),
            const SizedBox(height: 10,),
            Text(
              product.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 18,color: textColor),
            ),
            Text(
               product.desc,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: textColor),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₹ ${product.price}",
                 style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600, color: textColor),),
                const FavBtn(),
                
                    
              ],
            )
          ],
        ),
      ),
    );
  }
}
