

import 'package:cafe_app/services/api_response.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/services/orders_service.dart';
import 'package:get/get.dart';
import '../../widgets/custom_widgets.dart';
import '../home/home.dart';
import 'order_details.dart';
import '../../constraints/constants.dart';
import '../../components/news_card_skelton.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}
class _MyOrdersState extends State<MyOrders> {
  List<dynamic> _orderList = [].obs;
  bool _isLoading = true; // flag to track loading state
  final controller = ScrollController();
  final double itemSize = 150;
  late double opacity;
  late double scale;

  void onListenerController()
  {
    setState(() {
      
    });
  }

  @override
  void dispose()
  {
     super.dispose();
    // controller.removeListener(onListenerController);
    controller.dispose();
  }

  @override
  void initState() {

    Future.delayed(const Duration(seconds: 2),(){
        setState(() {
          _isLoading = true;
          _loadOrders(); 
        });
    });
    controller.addListener(onListenerController);
    super.initState();
    // load orders when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // set background color to black
      appBar: _buildAppBar(),
      body: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 10),
         child: _isLoading // show loading spinner if data is loading
            ?
            ListView.separated(
                itemCount: 5,
                itemBuilder: (context, index) => const NewsCardSkelton(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
              )
            : 
                Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: 
                        ListView.separated(
                          itemCount:  _orderList.length,
                          controller: controller,
                          itemBuilder: (context, index) {
                            final itemOffset = index * itemSize;
                            final difference = controller.offset - itemOffset;
                            final percent = 1 - (difference/(itemSize/2));
                            scale = percent;
                            opacity = percent;
                            if(opacity > 1.0) opacity = 1.0;
                            if(opacity < 0.0) opacity = 0.0;
                            if(scale > 1.0) scale = 1.0;
                            return orders(_orderList[index]);

                          },
                                   
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 30),
                        ),
                      ),
                    ),
                  ],                 
                ),
      ),
    );
  }

  Future<void> _loadOrders() async{
    ApiResponse response  = await getOrders(); // call order service to get orders
    if(response.error == null)
    {
       setState(() {
        _orderList = response.data as List<dynamic>;
        _isLoading = false;
      });
    }
    else{
       setState(() {
        _isLoading = true;
        print("Response Error ______________________________");
        showSnackBar(title: '${response.error}', message: '');
      });
    }
  }
   
  _buildAppBar(){
    return AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("My Orders", style: TextStyle(color: Colors.white),),
        elevation: 0.0,
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => Home()));
            }, 
            icon: Icon(Icons.arrow_back), color: Colors.white,),
            actions: [
              IconButton(
                onPressed: (){
                }, 
                icon: Icon(Icons.notifications_none))
            ],
      );
  }
  
  orders(product) {
    return GestureDetector(
      onTap: () {
        // print(product['id']);
        Navigator.push(context, MaterialPageRoute(builder: ((context) => OrderDetails(order_id: product['id']))));
        },
        child: Opacity(
          opacity: opacity,
          child: Transform(
            transform: Matrix4.identity()..scale(scale, 1.0),
            alignment: Alignment.center,
            child: Container(
                  height: itemSize,
                  width: double.infinity,
                  child: Card(
                    color: Colors.grey[900],
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 140,
                              width: 200,
                              child: ListTile(
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Order Id : ${product['id']}", style: TextStyle(color: Colors.white),),
                                      Text("Order Amount: ₹ ${product['price']} ", style: TextStyle(
                                        color: Color(0xff9b96d6),
                                        fontWeight: FontWeight.bold
                                      ),),
                                      Text("Date : ${product['date']}", style: TextStyle(color: Colors.white),),
                                      // Text(product.item_name, style: TextStyle(color: Colors.white),),
                                      // Text(product.item_name, style: TextStyle(color: Colors.white),),
                                      
                                    ],
                                  ),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Icon(Icons.chevron_right, color: Colors.grey[800], size: 50,),
                          ],
                        ),
                       
                      ],
                    ),
                  ),
            ),
          ),
        ),
    );
  }
  }
