import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                // crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(
                    height: 80, // adjust the height as needed
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BigText('Order Date: ${_orderList[0].order_date}',
                              textColor, Dimensions.font20),
                          SizedBox(height: Dimensions.height10),
                          BigText('Total Amount: ₹ ${_orderList[0].total}',
                              textColor, Dimensions.font20),
                        ],
                      ),
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
      centerTitle: true,
      title: Text(
        "#Order ${widget.order_id}",
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
