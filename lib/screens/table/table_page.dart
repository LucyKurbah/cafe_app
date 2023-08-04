import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/controllers/home_controller.dart';
import 'package:cafe_app/screens/home/components/table_card.dart';
import 'package:cafe_app/screens/user/login.dart';
import 'package:cafe_app/services/table_service.dart';
import 'package:cafe_app/services/cart_service.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/services/api_response.dart';
import '../../components/badge_widget.dart';
import 'package:cafe_app/api/apiFile.dart';
import 'package:cafe_app/models/Product.dart';
import 'package:cafe_app/screens/table/single_table_screen.dart';
import 'package:get/get.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class SeatWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        color: blueGrey, // You can change the color based on seat status (booked, available, etc.)
      ),
    );
  }
}

class _TablePageState extends State<TablePage> with TickerProviderStateMixin {
  final controller = HomeController();
  int userId = 0;
  bool _loading = true;
  List<dynamic> _productList = [].obs;
  String _cartMessage = '';

  @override
  void initState() {
    super.initState();
    retrieveProducts();
  }

  Future<void> retrieveProducts() async {
    userId = await getUserId();
    ApiResponse response = await getTables();
    if (response.error == null) {
      setState(() {
        _productList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == ApiConstants.unauthorized) {
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  Future<void> addCart(Product product) async {
    userId = await getUserId();

    ApiResponse response = await addToCart(product);
    if (response.error == null) {
      setState(() {
        //add the counter here
        //incrementCount();
        _cartMessage = response.data.toString();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_cartMessage)));
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == ApiConstants.unauthorized) {
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: greyColor9,
        appBar: AppBar(
          backgroundColor: mainColor,
           leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Center(child: BadgeWidget()),
            )
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () {
              return retrieveProducts();
            },
            child: SafeArea(
              bottom: false,
              child: Container(
                color: mainColor,
                child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      return LayoutBuilder(
                        builder: (context, BoxConstraints constraints) {
                          return Stack(
                            children: [
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 500),
                                top: 10,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text("Tables",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: textColor.withOpacity(0.5))),
                                ),
                              ),
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 500),
                                top: controller.homeState == HomeState.normal
                                    ? 50
                                    : -(constraints.maxHeight - 100 * 2 - 85),
                                left: 0,
                                right: 0,
                                height: constraints.maxHeight - 85,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20 * 1.5),
                                      bottomRight: Radius.circular(20 * 1.5),
                                    ),
                                  ),
                                  child: GridView.builder(
                                    itemCount: _productList.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.8,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                    ),
                                    itemBuilder: (context, index) => TableCard(
                                        table: _productList[index],
                                        press: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      SingleTableScreen(
                                                          _productList[
                                                              index]))));
                                        }),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }),
              ),
            )));
  }
}
