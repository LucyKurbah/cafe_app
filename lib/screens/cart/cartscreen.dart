import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:cafe_app/main.dart';
import 'package:cafe_app/screens/home/components/cart_card.dart';
import 'package:cafe_app/screens/home/home_screen.dart';
import 'package:cafe_app/screens/payment/razorpay.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/widgets/custom_widgets.dart';
import 'package:cafe_app/services/api_response.dart';
import 'package:cafe_app/api/apiFile.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:cafe_app/services/cart_service.dart';
import 'package:cafe_app/screens/user/login.dart';
import 'package:cafe_app/models/Cart.dart';
import 'package:cafe_app/screens/home/components/cart_detailsview_card.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import '../../components/news_card_skelton.dart';
import '../../models/TableCart.dart';
import 'coupon_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;
  String _cartMessage = '';
  List<dynamic> _cartList  = [], _tableList = [];
  double totalPrice= 0.0;
  double coupon_amount= 0.0;
  double discountedTotal= 0.0;
  late InAppWebViewController inAppWebViewController;
  double _progress = 0;
  int user_id =0;


  Future<void> goToPayment(cartList, totalPrice) async {
    ApiResponse response = await saveOrder(cartList, totalPrice);
    if (response.error == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    } else if (response.error == ApiConstants.unauthorized) {
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = true;
        retrieveCart();
        // retrieveTableCart();
      });
    });
    super.initState();
  }

  Future<void> retrieveCart() async {
    ApiResponse response = await getCart();
    if (response.error == null) {
      setState(() {
        _cartList = List<Cart>.from(response.data as List<dynamic>);
        _isLoading = _isLoading ? !_isLoading : _isLoading;
        retrieveTotal();
      });
    } else if (response.error == ApiConstants.unauthorized) {
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    } else {
      print(response.error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }
  
  Future<void> retrieveTableCart() async {
 

    ApiResponse response = await getTableCart();
    if (response.error == null) {
      setState(() {
        _tableList = List<TableCart>.from(response.data as List<dynamic>);
        _isLoading = _isLoading ? !_isLoading : _isLoading;
      });
    } else if (response.error == ApiConstants.unauthorized) {
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    } else {

      print(response.error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  Future<void> retrieveTotal() async {
    ApiResponse response = await getTotal();
    if (response.error == null) {
      setState(() {
        List<dynamic> totalAmount = response.data as List<dynamic>;
        print(totalAmount);
        totalPrice = double.parse(totalAmount[0]);
        coupon_amount = double.parse(totalAmount[1]);
        discountedTotal = double.parse(totalAmount[2]);
        user_id = int.parse(totalAmount[3].toString());
        _isLoading = _isLoading ? !_isLoading : _isLoading;
      });
    } else if (response.error == ApiConstants.unauthorized) {
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    } else {
      print("Retrieve Total error");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  Future<void> addCart(Cart cart) async {
    ApiResponse response = await incrementCart(cart);
    if (response.error == null) {
      _cartMessage = response.data.toString();
      _isLoading = _isLoading ? !_isLoading : _isLoading;
      retrieveTotal();
    } 
    else if (response.error == ApiConstants.unauthorized) {
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${response.error}"),
          duration: const Duration(seconds: 1)));
    }
  }

  Future<void> removeCart(Cart cart) async {
    ApiResponse response = await decrementCart(cart);
    if (response.error == null) {
      retrieveTotal();
      if (cart.count < 1) {
        setState(() {
          _cartList.remove(cart);
        });
      }
      
      _cartMessage = response.data.toString();
      _isLoading = _isLoading ? !_isLoading : _isLoading;
    } 
    else if (response.error == ApiConstants.unauthorized) {
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    } 
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${response.error}"),
          duration: const Duration(seconds: 1)));
    }
  }

  Future<bool> _makePaymentAPI() async {
    ApiResponse response = await makePayment(totalPrice);
    try {
      print(response.data);
      print("response.error");
      if (response.error == null) {
        print("NULL ERROR__________________");
        if (response.data == 200) {
          // showSnackBar(title: 'Payment Done', message: '');
          setState(() {
            print("Reteivinbg cart");
            retrieveCart();
            retrieveTableCart();
          });
          return true;
        } else {
          // showSnackBar(
          //     title: 'error', message: 'Payment Failed! Please Try Again');
          return false;
        }
      } else {
        // return false;
        throw Exception("API response error: ${response.error}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: mainColor,
        appBar: _buildAppBar(),
        body: _isLoading // show loading spinner if data is loading
            ? ListView.separated(
                itemCount: 5,
                itemBuilder: (context, index) => const NewsCardSkelton(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
              )
            : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartList.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 16, bottom: 115),
                     
                    itemBuilder: (context, index) {
                          final cart = _cartList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CartCard(
                              key: Key(cart.item_id.toString()),
                              cart: cart,
                              addItem: () {
                                setState(() {
                                  cart.count++;
                                });
                                addCart(cart);
                              },
                              removeItem: () {
                                setState(() {
                                  if (cart.count > 1) {
                                    cart.count--;
                                  } else {
                                    setState(() {
                                      _cartList.remove(cart);
                                    });
                                  }
                                });
                                removeCart(cart);
                              },
                            ),
                          );
                    },
                  ),
                ),
                _buildBottom(),
              ],
            ));
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: mainColor,
      centerTitle: false,
      title: Text(
        "Cart",
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
  // coupon()
  // {
  //   return GestureDetector(
  //     onTap: () {
  //       // print(product['id']);
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: ((context) => CartScreen())));
  //     },
  //     child: Container(
  //       height: 50,
  //       width: double.infinity,
  //       child: Card(
  //         color: greyColor,
  //         child: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 SizedBox(
  //                   height: 20,
  //                   width: 200,
  //                   child: ListTile(
  //                     title: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           "APPLY COUPON",
  //                           style: TextStyle(color: textColor),
  //                         ),
                        
  //                         // Text(product.item_name, style: TextStyle(color: textColor),),
  //                         // Text(product.item_name, style: TextStyle(color: textColor),),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 const Expanded(child: SizedBox()),
  //                 Icon(
  //                   Icons.chevron_right,
  //                   color: greyColor6,
  //                   size: 30,
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget coupon() {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: ((context) => CouponScreen())),
      );
    },
    child: Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(25), // Rounded edges
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 20), // Add space on the left side
          Expanded(
            child: Center(
              child: Text(
                "APPLY COUPON",
                style: TextStyle(color: textColor),
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: greyColor6,
            size: 30,
          ),
          SizedBox(width: 20), // Add space on the right side
        ],
      ),
    ),
  );
}
  Positioned _buildBottom() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: mainColor,
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 5),
        child: Column(
          children: [
            coupon(),
            SizedBox(height: Dimensions.height10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Text("Order Date",style: TextStyle(
                          color: greyColor6,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                  Text("${ DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                      style: TextStyle(
                          color: greyColor6,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0)),
              ],
            ),
            SizedBox(height: Dimensions.height10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Text("Sub Total",style: TextStyle(
                          color: greyColor6,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                  Text("₹ $totalPrice",
                      style: TextStyle(
                          color: greyColor6,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0)),
              ],
            ),
            SizedBox(height: Dimensions.height10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Text("Coupon",style: TextStyle(
                          color: greyColor6,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  Text("₹ $coupon_amount",
                      style: TextStyle(
                          color: greyColor6,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0)),
              ],
            ),
            SizedBox(height: Dimensions.height20,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Total",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  Text("₹ $discountedTotal",
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                ]),
            SizedBox(
              height: Dimensions.height20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      backgroundColor: tealColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // goToPayment(_cartList, totalPrice);
                      
                      // _loadUserInfo(context, totalPrice);
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: ((context) => Razorpay( discountedTotal: discountedTotal, user_id: user_id))
                        )
                      );
                    },
                    child: const Text(
                      "Checkout",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.height10,
            ),
            SizedBox(
              height: Dimensions.height20,
            ),
          ],
        ),
      ),
    );
  }

  void _showCheckoutDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: mainColor,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(30),
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            color: greyColor9,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            children: [
              ...List.generate(
                _cartList.length,
                (index) => CartDetailsViewCard(productItem: _cartList[index]),
              ),
              const Spacer(),
              Row(
                
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                         Text(
                          'Sub Total: $totalPrice',
                          style: TextStyle(
                            color: textColor,
                            fontSize: Dimensions.font15,
                          ),
                        ),
                       Text(
                          'Coupon: $coupon_amount',
                          style: TextStyle(
                            color: greyColor,
                            fontSize: Dimensions.font15,
                          ),
                        ),
                        SizedBox(height: Dimensions.height5,),
                        Text(
                              'Total: $discountedTotal',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.font20,
                              ),
                        ),
                     ],
                   ),
                  ElevatedButton(
                    onPressed: () {
                      // _showPaymentDialog(context);
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: ((context) => Razorpay(discountedTotal: discountedTotal, user_id: user_id,))));
                    },
                    child: const Text('Make Payment'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: _makePaymentAPI(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading dialog while waiting for the API response
              return WillPopScope(
                onWillPop: () => Future.value(false),
                child: Dialog(
                  backgroundColor: mainColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(textColor),
                        ),
                        const SizedBox(width: 16.0),
                        Text(
                          "Processing Payment...",
                          style: TextStyle(color: textColor),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              // Show an error dialog if the API call fails
              return AlertDialog(
                backgroundColor: mainColor,
                title: Text(
                  "Payment Error",
                  style: TextStyle(color: textColor),
                ),
                content: Text(
                  "An error occurred while processing your payment. Please try again later.",
                  style: TextStyle(color: textColor),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ],
              );
            } else {
              // Show payment confirmation dialog if the API call succeeds
              return AlertDialog(
                backgroundColor: mainColor,
                title: Text(
                  "Payment Done",
                  style: TextStyle(color: textColor),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.of(context).pop();
                      Navigator.of(context).pushNamed("/orders");
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  void _loadUserInfo(context, totalPrice) async {
    String token = await getToken();
    int user_id = await getUserId();
    if (token == '') {
      showSnackBar(title: 'Please Login first', message: '');
    } else {
      if (totalPrice == 0 || totalPrice == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No items in the cart')));
      } else if (user_id != 0) {
        _showCheckoutDetails(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Please Login first')));
      }
    }
  }
}
