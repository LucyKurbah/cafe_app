import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../components/news_card_skelton.dart';
import '../../services/api_response.dart';
import '../../services/orders_service.dart';
import '../../widgets/custom_widgets.dart';
import 'order_details_card.dart';

class OrderDetails extends StatefulWidget {
  OrderDetails({super.key, required this.order_id});

  int order_id;


  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List<dynamic> _orderList = [].obs;
  bool _isLoading = true;
  final DateTime currentTime = DateTime.now(); 

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 5), () {
      setState(() {
        _isLoading = true;
        _loadOrders(widget.order_id);
      });
    });
    super.initState();
    // load orders when the widget is initialized
  }

  Future<void> _loadOrders(order_id) async {
    ApiResponse response =
        await getOrdersDetails(order_id); // call order service to get orders
    if (response.error == null) {
      setState(() {
        _orderList = response.data as List<dynamic>;
       
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = true;
        showSnackBar(title: '${response.error}', message: '');
      });
    }
  }

// bool shouldShowExtendButton() {
//   print("_____++++++______++++++______+++++++_____++++");
 
//   if (_orderList.isNotEmpty && _orderList[0].time_to != null) {
//     String dateTimeString = "${DateTime.now().toString().split(" ")[0]} ${_orderList[0].time_to}";
//     DateTime timeTo = DateTime.parse(dateTimeString);
//      print(timeTo);
//      print(currentTime);
//     print(timeTo.isAfter(currentTime));
//     return timeTo.isAfter(currentTime);
//   }
//   return false; 
// }
  bool shouldShowExtendButton() {
    if (_orderList.isNotEmpty) {
      DateTime currentTime = DateTime.now();
      DateFormat dateFormat = DateFormat("MMM d'th', yyyy HH:mm:ss");
      DateTime timeTo = dateFormat.parse("${_orderList[0].table_date} ${_orderList[0].time_to}");

      // Case 1: If table_date is today's date
      if (_orderList[0].table_date == dateFormat.format(currentTime)) {
        return timeTo.isAfter(currentTime);
      }

      // Case 2: If table_date is after today's date
      DateTime tableDate = DateFormat("MMM d'th', yyyy").parse(_orderList[0].table_date);
      return tableDate.isAfter(currentTime);
    }

    return false; // Default to false if _orderList is empty
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
                mainAxisAlignment: MainAxisAlignment.start,
                
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ListView.separated(
                        itemCount: _orderList.length,
                        itemBuilder: (context, index) =>
                            OrderDetailsCard(product: _orderList[index]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SmallText('Order Date: ${_orderList[0].order_date}',
                            greyColor6, Dimensions.font15),
                        SizedBox(height: Dimensions.height10),
                        BigText('Total Amount: ₹ ${_orderList[0].total}',
                            textColor, Dimensions.font20),
                        SizedBox(height: Dimensions.height10),
                        Center(
                          child: Visibility(
                            visible: shouldShowExtendButton(),
                            child: 
                              ElevatedButton(
                                onPressed: () {
                                  if (_orderList.isNotEmpty) {
                                    final flag = _orderList[0].flag;
                                    if (flag == 'T') {
                                      Navigator.of(context).pushNamed('/table');
                                    } else if (flag == 'C') {
                                      Navigator.of(context).pushNamed('/conference');
                                    }
                                  }
                                },
                                
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey, // Button background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // Button border radius
                                  ),
                                ),
                                child: Text('Extend Time',style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 18,
                                                  letterSpacing: 0.7)),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: mainColor,
      // centerTitle: true,
      title: Text(
        "ORDER #${widget.order_id}",
        style: TextStyle(color: textColor),
      ),
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
        color: textColor,
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))
      ],
    );
  }
}
