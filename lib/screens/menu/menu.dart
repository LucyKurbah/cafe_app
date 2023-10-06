import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/controllers/home_controller.dart';
import 'package:cafe_app/models/AddOn.dart';
import 'package:cafe_app/screens/add_on/addOn_card.dart';
import 'package:cafe_app/screens/home/components/product_card.dart';
import 'package:cafe_app/screens/home/home_screen.dart';
import 'package:cafe_app/screens/user/login.dart';
import 'package:cafe_app/services/item_service.dart';
import 'package:cafe_app/services/product_service.dart';
import 'package:cafe_app/services/cart_service.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/services/api_response.dart';
import '../../components/badge_widget.dart';
import 'package:cafe_app/api/apiFile.dart';
import 'package:cafe_app/models/Product.dart';
import 'package:get/get.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  

  final controller = HomeController();
  late TabController _tabController;
  int userId = 0;
  bool _loading = true;

  List<dynamic> _productList = [].obs;
  List<dynamic> _itemList = [].obs;

  String _cartMessage = '';

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    super.initState();
    retrieveProducts();
    retrieveItems();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> retrieveProducts() async {
    ApiResponse response = await getProducts();
    if (response.error == null) {
      setState(() {
        _productList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
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

  Future<void> retrieveItems() async {
    // userId = await getUserId();
    print("World");
    ApiResponse response = await getItems();
    if (response.error == null) {
      setState(() {
        _itemList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
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

  Future<void> addCart(Product product) async {
    userId = await getUserId();

    ApiResponse response = await addToCart(product);
    if (response.error == null) {
      setState(() {
        //add the counter here
        //incrementCount();
        retrieveItems();
        _cartMessage = response.data.toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_cartMessage),
          duration: const Duration(seconds: 1),
        ));
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == ApiConstants.unauthorized) {
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${response.error}"),
          duration: const Duration(seconds: 1)));
    }
  }

  Future<void> addItemCart(AddOn product) async {
    userId = await getUserId();

    ApiResponse response = await addItemToCart(product);
    if (response.error == null) {
      setState(() {
        //add the counter here
        //incrementCount();
        retrieveItems();
        _cartMessage = response.data.toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_cartMessage),
            duration: const Duration(seconds: 1)));
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == ApiConstants.unauthorized) {
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${response.error}"),
          duration: const Duration(seconds: 1)));
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
              padding:  EdgeInsets.only(right: 20.0),
              child: Center(
                child: BadgeWidget(),
              ),
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
                                  color: mainColor,
                                  child: TabBar(
                                    padding: const EdgeInsets.only(
                                        left: 13, right: 10),
                                    controller: _tabController,
                                    isScrollable: true,
                                    // indicator: CircleTabIndicator(color: Color(0xffd17842), radius: 4),
                                    indicator:  UnderlineTabIndicator(
                                        borderSide: BorderSide(
                                            width: 3, color: iconColors1),
                                        insets:const EdgeInsets.symmetric(
                                            horizontal: 16)),
                                    labelColor: iconColors1,
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                    unselectedLabelColor:
                                        textColor.withOpacity(0.5),
                                    tabs: const [
                                      Tab(
                                        text: "Food Items",
                                      ),
                                      Tab(
                                        text: "Add On",
                                      ),
                                    ],
                                    onTap: (index) {
                                      // Update the state to toggle the add-on content visibility
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 500),
                                top: controller.homeState == HomeState.normal
                                    ? 85
                                    : -(constraints.maxHeight - 100 * 2 - 85),
                                left: 0,
                                right: 0,
                                height: constraints.maxHeight - 85 - 100,
                                child: _tabController.index == 0
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration:  BoxDecoration(
                                          color: mainColor,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft:
                                                Radius.circular(20 * 1.5),
                                            bottomRight:
                                                Radius.circular(20 * 1.5),
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
                                            itemBuilder: (context, index) {
                                              final product =
                                                  _productList[index];
                                              return ProductCard(
                                                product: product,
                                                press: () {
                                                  // controller.addProductToCart(_productList[index]);
                                                  addCart(_productList[index]);
                                                },
                                                addItem: () {
                                                  addCart(_productList[index]);
                                                },
                                                removeItem: () {
                                                  addCart(_productList[index]);
                                                },
                                              );
                                            }),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration:  BoxDecoration(
                                          color: mainColor,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft:
                                                Radius.circular(20 * 1.5),
                                            bottomRight:
                                                Radius.circular(20 * 1.5),
                                          ),
                                        ),
                                        child: GridView.builder(
                                          itemCount: _itemList.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.8,
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10,
                                          ),
                                          itemBuilder: (context, index) =>
                                              AddOnCard(
                                                  product: _itemList[index],
                                                  press: () {
                                                    // controller.addProductToCart(_itemList[index]);
                                                    addItemCart(
                                                        _itemList[index]);
                                                  },
                                                  addItem: (() {
                                                    addItemCart(
                                                        _itemList[index]);
                                                  }),
                                                  removeItem: () {
                                                    print("Removed");
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
