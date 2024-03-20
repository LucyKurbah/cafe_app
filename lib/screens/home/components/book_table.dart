
import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:cafe_app/models/Table.dart';
import 'package:flutter/material.dart';
import '../../../constraints/constants.dart';
import 'package:cafe_app/components/fav_btn.dart';

class BookTable extends StatefulWidget {


  const BookTable({
    Key? key,
    required this.table,
    required this.press,
    required this.addItem,
  }) : super(key: key);

  final TableModel table;

  final VoidCallback addItem;
  final void Function(bool param, int param2) press;

  @override
  State<BookTable> createState() => _BookTableState();
}

class _BookTableState extends State<BookTable> {
   bool tapped = false;
   int val=0;

    
  @override
  Widget build(BuildContext context) {
    // List<Widget> containers = [];
    // if (widget.table.table_seats == 4) {
    // }
  
  void _onTap() {
    setState(() {
      if (widget.table.order_id == null) {
        tapped = !tapped;
        val=0;
      
      //   if (tapped) {
      //     widget.press(); // Call the press function
      //   } else {
      //     widget.addItem(); // Call the addItem function
      //   }
      }
      else
      {
        val=1;    // Table has already been booked
      }
      widget.press(tapped,val);
    });

  }
   return GestureDetector(
    onTap: _onTap, 
     child:     
      Container(
       padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
         
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                Container(
                  height: 25,
                  width: 20,
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                    decoration: BoxDecoration(
                      color: tapped ? Color.fromARGB(255, 18, 65, 60) : greyColor7,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),),
                  Container(
                  height: 25,
                  width: 20,
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                    decoration: BoxDecoration(
                      color: tapped ? Color.fromARGB(255, 18, 65, 60) : greyColor7,//(widget.table.order_id == null ? greyColor : greyColor8),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),),
                  
              ],
            ),
          SizedBox(width: 10,),
          Container(
            width: 60,
              padding: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                // color: tapped ? const Color.fromARGB(255, 11, 83, 76) : (widget.table.order_id == null ? greyColor : greyColor8),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ), 
                border: Border.all(
                  color: tapped ?  Color.fromARGB(255, 11, 83, 76): greyColor, // Set the border color to teal
                  width: 2, // Set the border width as desired
                ),            
              ),
               child: Center(
                 child: Column(
                   children: [
                    SizedBox(height: 20,),
                     Text(
                       "T-0${widget.table.id}", 
                       style: TextStyle(color: greyColor7),
                     ),
                     SizedBox(height: 10,),
                      Text("${widget.table.table_seats} seats", style: TextStyle(color: greyColor7))
                   ],
                 ),
               ),
              // child: Text('${widget.table.id}'),
          ),
          
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               Container(
                height: 25,
                width: 20,
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  decoration: BoxDecoration(
                    color: tapped ? Color.fromARGB(255, 18, 65, 60) : greyColor7,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(7),
                    ),
                    
                  ),),
                Container(
                height: 25,
                width: 20,
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  decoration: BoxDecoration(
                    color: tapped ? Color.fromARGB(255, 18, 65, 60) : greyColor7,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(7),
                    ),
                  ),),
                 
             ],
           ), 
         ],
       ),
     ),
   );
  }
}