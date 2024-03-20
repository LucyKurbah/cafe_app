import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/screens/home/home_screen.dart';
import 'package:cafe_app/services/api_response.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/services/orders_service.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_widgets.dart';
import 'order_details.dart';
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

  List<String> items = [
    "Processing",
    "Completed"
  ];

  List<IconData> icons =[
    Icons.home,
    Icons.done_all_outlined
  ];
  int current = 0;

  void onListenerController() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = true;
        _loadOrders();
      });
    });
    controller.addListener(onListenerController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor, // set background color to black
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: _isLoading // show loading spinner if data is loading
            ? ListView.separated(
                itemCount: 5,
                itemBuilder: (context, index) => const NewsCardSkelton(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: items.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index){
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    current = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: EdgeInsets.all(10),
                                  width: 80,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: current==index
                                            ?textColor
                                            :greyColor6,
                                    borderRadius: current == index
                                    ? BorderRadius.circular(15)
                                    : BorderRadius.circular(10),
                                    border: current == index
                                    ? Border.all(color: greyColor, width: 2)
                                    : null
                                    ),
                                  child: Center(
                                    child: Text(
                                      items[index],
                                      style: GoogleFonts.laila(
                                        fontWeight: FontWeight.w500,
                                        color: current == index 
                                        ? mainColor
                                        : textColor
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: current ==index,
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: textColor
                                  ),
                              ))
                            ],
                          );
                      }),
                  ),
                //  Container(
                //   margin: EdgeInsets.only(top: 30),
                //   width: double.infinity,
                //   height: 500,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Icon(icons[current], size: 200, color: textColor,),
                //       SizedBox(height: 10,),
                //       Text(items[current], style: GoogleFonts.laila(
                //         fontWeight: FontWeight.w500,
                //         color:greyColor6,
                //         fontSize: 30
                //       ))
                //     ],
                //   ),
                //  ),
                  Expanded(
                    child: SizedBox(
                      child: ListView.separated(
                        itemCount: _orderList.length,
                        controller: controller,
                        itemBuilder: (context, index) {
                          // final itemOffset = index * itemSize;
                          // final difference = controller.offset - itemOffset;
                          // final percent = 1 - (difference/(itemSize/2));
                          // scale = percent;
                          // opacity = percent;
                          // if(opacity > 1.0) opacity = 1.0;
                          // if(opacity < 0.0) opacity = 0.0;
                          // if(scale > 1.0) scale = 1.0;
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

  Future<void> _loadOrders() async {
    print("Load Orders");
    ApiResponse response =
        await getOrders(); // call order service to get orders
    if (response.error == null) {
      setState(() {
        _orderList = response.data as List<dynamic>;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = true;
        print("Response Error ______________________________");
        showSnackBar(title: '${response.error}', message: '');
      });
    }
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: mainColor,
      centerTitle: false,
      title: Text(
        "My Orders",
        style: TextStyle(color: textColor),
      ),
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const HomeScreen()));
        },
        icon: const Icon(Icons.arrow_back),
        color: textColor,
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))
      ],
    );
  }

  orders(product) {
    return GestureDetector(
      onTap: () {
        // print(product['id']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => OrderDetails(order_id: product['id']))));
      },
      child: Container(
        height: itemSize,
        width: double.infinity,
        child: Card(
          color: greyColor9,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 140,
                    width: 200,
                    child: ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ORDER #${product['id']}",
                            style: TextStyle(color: textColor),
                          ),
                          Text(
                            " ₹ ${product['price']} ",
                            style:  TextStyle(
                                color: lightBlueGrey,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " ${product['date']}",
                            style: TextStyle(color: greyColor),
                          ),
                          // Text(product.item_name, style: TextStyle(color: textColor),),
                          // Text(product.item_name, style: TextStyle(color: textColor),),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(
                    Icons.chevron_right,
                    color: greyColor8,
                    size: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
