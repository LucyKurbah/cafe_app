
import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:cafe_app/models/Table.dart';
import 'package:flutter/material.dart';
import '../../../constraints/constants.dart';

class TableCard extends StatelessWidget {


  const TableCard({
    Key? key,
    required this.table,
    required this.press,
  }) : super(key: key);

  final TableModel table;

  final VoidCallback press;

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
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 120,
              width: MediaQuery.of(context).size.width,
              child:
                    Hero(
                      tag: '${table.id}',
                      child: Image.network(
                         table.image,
                          fit: BoxFit.contain,
                          scale: 0.4,
                        ),
                    )
                   
            ),
            SizedBox(height: Dimensions.height10,),
            Text(
              table.table_name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 18,color: textColor),
            ),
            SizedBox(height: Dimensions.height5,),
            Text(
               '${table.table_seats} seats',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: textColor),
            ),
             SizedBox(height: Dimensions.height20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₹ ${table.price}",
                 style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600, color: textColor),),
                // const FavBtn(),
              ],
            )
          ],
        ),
      ),
    );
  }
}