import 'package:cafe_app/components/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemsWidget extends StatelessWidget {
  List<Map<String, dynamic>> gridMap = [
    {"name": "A", "price": "100", "images": "Assets/food/one.jpg"},
    {"name": "B", "price": "170", "images": "Assets/food/two.jpg"},
    {"name": "C", "price": "200", "images": "Assets/food/three.jpg"},
    {"name": "D", "price": "190", "images": "Assets/food/four.jpg"},
    {"name": "E", "price": "190", "images": "Assets/food/three.jpg"}
  ];

  ItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: (150 / 195)),
      shrinkWrap: true,
      itemCount: gridMap.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: darkGrey,
              boxShadow: [
                BoxShadow(
                    color: mainColor.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 8)
              ]),
          child: Column(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Image.asset(
                    "${gridMap.elementAt(index)['images']}",
                    scale: 0.4,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${gridMap.elementAt(index)['name']}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${gridMap.elementAt(index)['price']}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹ ${gridMap.elementAt(index)['price']}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: textColor),
                    ),
                    Container(
                        padding: const EdgeInsets.all(5),
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: iconColors1,
                            borderRadius: BorderRadius.circular(20)),
                        child: InkWell(
                          child: Icon(
                            CupertinoIcons.add,
                            size: 20,
                            color: textColor,
                          ),
                          onTap: () {
                            print("The icon is clicked");
                          },
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
