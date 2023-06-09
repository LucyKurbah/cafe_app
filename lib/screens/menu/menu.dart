import 'package:badges/badges.dart';
import 'package:cafe_app/controllers/home_controller.dart';
import 'package:cafe_app/db/db_helper.dart';
import 'package:cafe_app/models/AddOn.dart';
import 'package:cafe_app/screens/add_on/addOn_page.dart';
import 'package:cafe_app/screens/add_on/addOn_card.dart';
import 'package:cafe_app/screens/home/components/product_card.dart';
import 'package:cafe_app/screens/user/login.dart';
import 'package:cafe_app/screens/home/home.dart';
import 'package:cafe_app/services/item_service.dart';
import 'package:cafe_app/services/product_service.dart';
import 'package:cafe_app/services/cart_service.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/models/user_model.dart';
import 'package:cafe_app/services/api_response.dart';
import 'package:provider/provider.dart';
import '../../components/badge_widget.dart';
import '../../models/Cart.dart';
import '../home/components/cart_details_view.dart';
import '../home/components/cart_short_view.dart';
import 'package:cafe_app/api/apiFile.dart';
import 'package:cafe_app/models/Product.dart';
import 'package:cafe_app/screens/cart/cartscreen.dart';
import 'package:get/get.dart';


class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with SingleTickerProviderStateMixin {


  DBHelper? dbHelper = DBHelper();

  late List<UserModel>? _userModel = [];
  final controller = HomeController();
  late TabController _tabController;
  String _cartTag = "";
  int userId = 0;
  bool _loading = true;
  bool _addOnVisible = false;

  List<dynamic> _productList = [].obs;
  List<dynamic> _itemList = [].obs;

  String _cartMessage = '';
  
  @override
  void initState(){
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    super.initState();
    retrieveProducts();
    retrieveItems();
  }

  _handleTabSelection(){
    if(_tabController.indexIsChanging){
      setState(() {
      });
    }
  }

  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }

  void _onVerticalGesture(DragUpdateDetails details) {
    setState(() {
        if (details.primaryDelta! < -0.7) {
      controller.changeHomeState(HomeState.cart);
    } else if (details.primaryDelta! > 12) {
      controller.changeHomeState(HomeState.normal);
    }
    });
  }

  Future<void> retrieveProducts() async{
    ApiResponse response = await getProducts();
    if(response.error == null)
    {
      setState(() {
        _productList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if(response.error == ApiConstants.unauthorized){
            logoutUser();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                                      builder: (context) => Home()
                                                                ), 
                                                (route) => false);
     
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  Future<void> retrieveItems() async{
    // userId = await getUserId();
    print("World");
    ApiResponse response = await getItems();
    if(response.error == null)
    {
      setState(() {
        _itemList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if(response.error == ApiConstants.unauthorized){
            logoutUser();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                                      builder: (context) => Home()
                                                                ), 
                                                (route) => false);
     
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }
   
  Future<void> addCart(Product product) async{
    userId = await getUserId();

    ApiResponse response = await addToCart(product);
    if(response.error == null)
    {
      setState(() {
        //add the counter here
        //incrementCount();
        retrieveItems();
        _cartMessage = response.data.toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${_cartMessage}"),duration: Duration(seconds: 1),));
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if(response.error == ApiConstants.unauthorized){
          logoutUser();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                                      builder: (context) => Login()
                                                                ), 
                                                (route) => false);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}"),duration: Duration(seconds: 1)));
    }
  }

  Future<void> addItemCart(AddOn product) async{
    userId = await getUserId();

    ApiResponse response = await addItemToCart(product);
    if(response.error == null)
    {
      setState(() {
        //add the counter here
        //incrementCount();
        retrieveItems();
        _cartMessage = response.data.toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${_cartMessage}"),duration: Duration(seconds: 1)));
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if(response.error == ApiConstants.unauthorized){
          logoutUser();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                                      builder: (context) => Login()
                                                                ), 
                                                (route) => false);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}"),duration: Duration(seconds: 1)));
    }
  }


  @override
  Widget build(BuildContext context) {
    final newCart = Provider.of<HomeController>(context);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:20.0),
            child: Center(
              child: BadgeWidget(),
            ),
          )
          
        ],
      ),
     
      body: RefreshIndicator(
        onRefresh: (){
          return retrieveProducts();
        },
        child:
            SafeArea(
              bottom: false,
              child: Container(
                color: Colors.black,
                child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      return LayoutBuilder(
                        builder: (context, BoxConstraints constraints) {
                          return Stack(
                            children: [          
                              AnimatedPositioned(
                                  duration: Duration(milliseconds: 500),
                                  top: 10,
                                  left: 0,
                                    right: 0,
                                    child: Container(
                                      color: Colors.black,
                                      child: TabBar(
                                        
                                                    padding: EdgeInsets.only(left:13, right: 10),
                                                    controller: _tabController,
                                                    isScrollable: true,
                                                    // indicator: CircleTabIndicator(color: Color(0xffd17842), radius: 4),
                                                    indicator: const UnderlineTabIndicator(
                                                      borderSide: BorderSide(
                                                        width: 3,
                                                        color: Color(0xffE57734)
                                                      ),
                                                      insets: EdgeInsets.symmetric(horizontal: 16)
                                                    ),
                                                    labelColor: Color(0xffd17842),
                                                    labelStyle: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16
                                                    ),
                                                    unselectedLabelColor: Colors.white.withOpacity(0.5),
                                                      tabs:[
                                                        Tab(text: "Food Items",),
                                                        Tab(text: "Add On",),
                                                       
                                                      ],
                                                        onTap: (index) {
                                                          // Update the state to toggle the add-on content visibility
                                                          setState(() {
                                                            _addOnVisible = index == 1;
                                                          });
                                                        },
                                              ),
                                    ),
                              ),               
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 500),
                                  top: controller.homeState == HomeState.normal
                                    ? 85
                                    : -(constraints.maxHeight -
                                        100 * 2 -
                                        85),
                                   
                                  left: 0,
                                  right: 0,
                                  height: constraints.maxHeight -85 -100,                                  
                                  child: _tabController.index == 0?
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(20 * 1.5),
                                              bottomRight:
                                                  Radius.circular(20 * 1.5),
                                            ),
                                          ),
                                          child: GridView.builder(
                                            itemCount:  _productList.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 0.8,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                            ),
                                            itemBuilder: (context, index){ 
                                                final product = _productList[index];
                                                return ProductCard(
                                                    product: product,
                                                    press: () {                                       
                                                            // controller.addProductToCart(_productList[index]);
                                                            addCart(_productList[index]);
                                                            _cartTag = '_cartTag';                                           
                                                    } ,
                                                    addItem: () {
                                                          addCart(_productList[index]);
                                                      },
                                                    removeItem: () {
                                                          addCart(_productList[index]);
                                                      },                                      
                                                  );
                                            }
                                          ),
                                        ): Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(20 * 1.5),
                                              bottomRight:
                                                  Radius.circular(20 * 1.5),
                                            ),
                                          ),
                                          child: GridView.builder(
                                            itemCount:  _itemList.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              // childAspectRatio: 0.8,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                            ),
                                            itemBuilder: (context, index) => AddOnCard(
                                              product: _itemList[index],
                                              press: () {                                       
                                                      // controller.addProductToCart(_itemList[index]);
                                                      addItemCart(_itemList[index]);
                                                      _cartTag = '_cartTag';                                           
                                              },
                                               addItem: (() {
                                                addItemCart(_itemList[index]);                                            
                                              }),
                                              removeItem:() {
                                                print("Removed");       
                                              }  
                                                                                     
                                            ),
                                          ),
                                        ),
                              ),
                              // Card Panel
                              // AnimatedPositioned(
                              //   duration: const Duration(milliseconds: 500),
                              //   bottom: 0,
                              //   left: 0,
                              //   right: 0,
                              //   height: controller.homeState == HomeState.normal
                              //       ? 100
                              //       : (constraints.maxHeight - 100),
                              //   child: GestureDetector(
                              //     onVerticalDragUpdate: _onVerticalGesture,
                              //     child: Container(
                              //       padding: const EdgeInsets.all(20),
                                  
                              //       decoration: const BoxDecoration(
                              //               color: Colors.white24,
                              //               borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                              //       ),
                              //       alignment: Alignment.topLeft,
                              //       child: AnimatedSwitcher(
                              //         duration: const Duration(milliseconds: 500),
                              //         child: controller.homeState == HomeState.normal
                              //             ? CardShortView(controller: controller)
                              //             : CartDetailsView(controller: controller),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          );
                        },
                      );
                    }
                    ),
              ),
            )
    )
    );
  }
}