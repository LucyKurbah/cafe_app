import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ItemsWidget extends StatelessWidget {


   List<Map<String,dynamic>> gridMap = [

    {
      "name": "A",
      "price" : "100",
      "images": "Assets/food/one.jpg"
    },
    {
      "name": "B",
      "price" : "170",
      "images": "Assets/food/two.jpg"
    },
    {
      "name": "C",
      "price" : "200",
      "images": "Assets/food/three.jpg"
    },
    {
      "name": "D",
      "price" : "190",
      "images": "Assets/food/four.jpg"
    },
     {
      "name": "E",
      "price" : "190",
      "images": "Assets/food/three.jpg"
    }
    
    
  ];

          
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    childAspectRatio: (150/195)
                    ),
            shrinkWrap: true,
            itemCount: gridMap.length, 
            itemBuilder: (BuildContext context, int index) { 
            return Container(
                // height: 40,
                // width: 40,
                // padding: EdgeInsets.symmetric(vertical: 10),
                // decoration: BoxDecoration(
                //       color: Color(0xff3a3e3e),
                //       borderRadius: BorderRadius.circular(20)
                // ),
                // child: Column(
                //   children: [
                //   CircleAvatar(
                //     backgroundImage: AssetImage("${gridMap.elementAt(index)['images']}"),
                //     radius: 70,
                //   ),
                //   ListTile(
                //     leading: Text("${gridMap.elementAt(index)['name']}", style: TextStyle(fontSize: 17, color: Colors.white),),
                //     trailing: Text("₹ ${gridMap.elementAt(index)['price']}", style: TextStyle(fontSize: 17,color: Colors.white),),
                //   ),
                //   Padding(
                //     padding: const EdgeInsets.only(left: 12,top: 10),
                //     child: Row(
                //       children: [
                //         Icon(Icons.star, color: Colors.white,size: 15,),
                //         Icon(Icons.star, color: Colors.white,size: 15,),
                //         Icon(Icons.star, color: Colors.white,size: 15,),
                //         Icon(Icons.star, color: Colors.white,size: 15,),
                //         Icon(Icons.star, color: Colors.white,size: 15,),
      
                //       ],
                //     ),
                //   )
                //   ],
                // ),
    
    
    
                padding: EdgeInsets.symmetric(vertical: 5 , horizontal: 8),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF212325),
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 8
                  )
                  ]
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Image.asset(
                              "${gridMap.elementAt(index)['images']}",
                              scale: 0.4,
                              fit: BoxFit.contain,),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
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
                                color: Colors.white
                              ),
                            ),
                            SizedBox(height: 8,),
                             Text(
                              "${gridMap.elementAt(index)['price']}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white60
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹ ${gridMap.elementAt(index)['price']}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                              ),
                          ),
                          Container(
                            padding:  EdgeInsets.all(5),
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              color: Color(0xFFE57734),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: InkWell(
                                    child: Icon( CupertinoIcons.add,size: 20,color: Colors.white,),
                                    onTap: (){
                                             
                                              print("The icon is clicked");
                                          },
                                    )
                      
                          )
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