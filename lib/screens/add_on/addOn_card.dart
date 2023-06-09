
import 'package:cafe_app/components/fav_check.dart';
import 'package:cafe_app/models/AddOn.dart';
import 'package:flutter/material.dart';
import '../../api/apiFile.dart';
import '../../constraints/constants.dart';
import '../../services/api_response.dart';
import '../../services/cart_service.dart';
import '../../services/user_service.dart';

class AddOnCard extends StatelessWidget {

  AddOnCard({
    Key? key,
    required this.product,
     required this.addItem, required this.removeItem,
    required this.press,
  }) : super(key: key);

  final AddOn product;
  final VoidCallback  addItem, removeItem,press;


  bool rememberMe = false;

  bool checkedValue = false;

  int userId = 0;

  // Future<void> addCart(AddOn item) async{
  @override
  Widget build(BuildContext context) {
    return
     Container(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding * 1.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      child:
                            Image.network(
                               product.image,
                                fit: BoxFit.contain,
                                scale: 0.4,
                              )
                           
                    ),
          const SizedBox(height: 10,),
          Text(
            product.title,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.w600, fontSize: 18,color: Colors.white),
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("₹ ${product.price}",
               style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.w600, color: Colors.white),),
              
            
               Container(
                padding: EdgeInsets.only(top:5,bottom: 5,left: 10,right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xffE57734)
                ),
                child: 
                product.quantity == null || product.quantity == 0?
                        
                        InkWell(
                          child: Text("Add", style: TextStyle(color: Colors.white)
                          ),
                          onTap: addItem,
                          )
                          :
                             Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    
                                    children: [
                                      GestureDetector(
                                        child: Text("- ", style: TextStyle(color: Colors.white,fontSize: 25, fontWeight: FontWeight.bold)),
                                        onTap:removeItem
                                      ),
                                      SizedBox(width: 10,),
                                      Text("${product.id}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                       GestureDetector(
                                        child: Icon(Icons.add, color: Colors.white),
                                        onTap: addItem,
                                      ),
                                      
                                    ],
                                  ),
              ),
            ],
          ),    
        ],
      ),
      
       );   
  }
}

