import 'package:badges/badges.dart';
import 'package:cafe_app/controllers/home_controller.dart';
import 'package:cafe_app/db/db_helper.dart';
import 'package:cafe_app/models/ProductItem.dart';
import 'package:cafe_app/screens/home/components/product_card.dart';
import 'package:cafe_app/screens/user/login.dart';
import 'package:cafe_app/services/product_service.dart';
import 'package:cafe_app/services/cart_service.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:cafe_app/models/user_model.dart';
import 'package:cafe_app/services/api_response.dart';
import 'package:provider/provider.dart';
import '../../components/badge_widget.dart';
import '../home/components/cart_details_view.dart';
import '../home/components/cart_short_view.dart';
import 'package:cafe_app/api/apiFile.dart';
import 'package:cafe_app/models/Product.dart';
import 'package:cafe_app/screens/cart/cartscreen.dart';


class TableCard extends StatefulWidget {
  const TableCard({super.key});

  @override
  State<TableCard> createState() => _TableCardState();
}

class _TableCardState extends State<TableCard> with TickerProviderStateMixin{


  DBHelper? dbHelper = DBHelper();

  late List<UserModel>? _userModel = [];
  final controller = HomeController();
  late TabController _tabController;
  String _cartTag = "";
  int userId = 0;
  bool _loading = true;

  List<dynamic> _productList = [];

  String _cartMessage = '';
  
  @override
  void initState(){
    _tabController = TabController(length: 7, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    super.initState();
    retrieveProducts();
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
    userId = await getUserId();
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
        _cartMessage = response.data.toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${_cartMessage}")));
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if(response.error == ApiConstants.unauthorized){
      logoutUser();
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }




  @override
  Widget build(BuildContext context) {
    final newCart = Provider.of<HomeController>(context);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:20.0),
            child: Center(
              child: BadgeWidget(),
            ),
          )
          // IconBtnWithCounter(
          //   svgSrc: "Assets/Images/cart.svg",
          //   press:() {},
          //  ),
          //  IconBtnWithCounter(
          //   svgSrc: "Assets/Images/bell.svg",
          //   numOfItems: 3,
          //   press:() {},
          //  ),
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
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 16
                                                    ),
                                                    unselectedLabelColor: Colors.white.withOpacity(0.5),
                                                      tabs:[
                                                        Tab(text: "All",),
                                                        Tab(text: "Starters",),
                                                        Tab(text: "Main Course",),
                                                        Tab(text: "Desserts",),
                                                        Tab(text: "Beverages",),
                                                        Tab(text: "Desserts",),
                                                        Tab(text: "Beverages",),
                                                      ]
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
                                  height: constraints.maxHeight -
                                    85 -
                                    100,
                                  
                                child: Container(
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
                                    itemBuilder: (context, index) => ProductCard(
                                      product: _productList[index],
                                      press: () {
                                        
                                              controller.addProductToCart(_productList[index]);
                                              addCart(_productList[index]);
                                              _cartTag = '_cartTag';

                                            
                                      },  
                                      addItem:() {
                                        
                                      },
                                       removeItem:() {
                                        
                                      },
                                                                     
                                    ),
                                  ),
                                ),
                              ),
                              // Card Panel
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 500),
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: controller.homeState == HomeState.normal
                                    ? 100
                                    : (constraints.maxHeight - 100),
                                child: GestureDetector(
                                  onVerticalDragUpdate: _onVerticalGesture,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                  
                                    decoration: const BoxDecoration(
                                            color: Colors.white24,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                                    ),
                                    alignment: Alignment.topLeft,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 500),
                                      child: controller.homeState == HomeState.normal
                                          ? CardShortView(controller: controller)
                                          : CartDetailsView(controller: controller),
                                    ),
                                  ),
                                ),
                              ),
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