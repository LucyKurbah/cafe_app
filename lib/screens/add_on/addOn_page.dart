import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/controllers/home_controller.dart';
import 'package:cafe_app/screens/home/home_screen.dart';
import 'package:cafe_app/services/item_service.dart';
import 'package:cafe_app/services/cart_service.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/services/api_response.dart';
import '../../components/badge_widget.dart';
import 'addOn_card.dart';
import 'package:cafe_app/api/apiFile.dart';
import 'package:cafe_app/models/AddOn.dart';
import 'package:get/get.dart';
import 'package:cafe_app/constraints/constants.dart';

class AddOnPage extends StatefulWidget {
  const AddOnPage({super.key});

  @override
  State<AddOnPage> createState() => _AddOnPageState();
}

class _AddOnPageState extends State<AddOnPage> with TickerProviderStateMixin {
  final controller = HomeController();
  int userId = 0;
  bool _loading = true;
  List<dynamic> _productList = [].obs;
  String _cartMessage = '';

  @override
  void initState() {
    super.initState();
    retrieveItems();
  }

  Future<void> retrieveItems() async {
    ApiResponse response = await getItems();
    if (response.error == null) {
      setState(() {
        _productList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == ApiConstants.unauthorized) {
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  Future<void> addCart(AddOn item) async {
    userId = await getUserId();

    ApiResponse response = await addItemToCart(item);
    if (response.error == null) {
      setState(() {
        _cartMessage = response.data.toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_cartMessage), duration: const Duration(seconds: 1)));
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == ApiConstants.unauthorized) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error occurred")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${response.error}")));
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: greyColor9,
        appBar: _buildAppBar(),
        body: RefreshIndicator(
            onRefresh: () {
              return retrieveItems();
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
                                top: controller.homeState == HomeState.normal
                                    ? 50
                                    : -(constraints.maxHeight - 100 * 2 - 50),
                                left: 0,
                                right: 0,
                                height: constraints.maxHeight - 100,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration:  BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.only(
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
                                    itemBuilder: (context, index) => AddOnCard(
                                        product: _productList[index],
                                        press: () {
                                          controller.addProductToCart(
                                              _productList[index]);
                                          addCart(_productList[index]);
                                        },
                                        addItem: () {
                                          addCart(_productList[index]);
                                        },
                                        removeItem: () {
                                          print("Deleted");
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

  _buildAppBar() {
    return AppBar(
      backgroundColor: mainColor,
      centerTitle: true,
      title: Text(
        "Add On Items",
        style: TextStyle(color: textColor),
      ),
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (ctx) => const HomeScreen()));
        },
        icon: const Icon(Icons.arrow_back),
        color: textColor,
      ),
      actions: const [
        Padding(
          padding:EdgeInsets.only(
              right: defaultPadding, left: defaultPadding),
          child: Center(
            child: BadgeWidget(),
          ),
        )
      ],
    );
  }
}
