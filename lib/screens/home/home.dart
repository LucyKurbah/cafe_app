import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/screens/cart/cartscreen.dart';
import 'package:flutter/material.dart';
import '../../components/dimensions.dart';
import '../../models/user_model.dart';
import '../../services/api_response.dart';
import '../../widgets/custom_widgets.dart';
import 'event_body.dart';
import 'home_card.dart';
import '../user/login.dart';
import '../orders/my_orders.dart';
import '../profile/profile.dart';
import 'dart:math';
import 'package:cafe_app/services/user_service.dart';
import 'package:get/get.dart';

 class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{

  late TabController tabController;
  double value = 0;
  String username ='';
  bool isLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 4, vsync: this);
    getUserDetail();
    super.initState();
  }

  void getUserDetail() async{
    
    ApiResponse response = await getUserDetails();
    if(response.error == null){
      UserModel user = response.data as UserModel;
      username = user.name;
      isLoggedIn = true;
    }
    else{
    //  showSnackBar(title: 'Error', message: '${response.error}');
      isLoggedIn = false;
      username ='';
    }
  }

  void login()
  {
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>Login()), (route) => false);
  }

  void logout()
  {
    logoutUser();
    getUserDetail();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
    showSnackBar(title: '', message: 'Logged Out');
    
  }

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(context),
      drawer: Drawer(
                  child: _drawerView(_screenSize, context),
              ),
      body: buildHome(context),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mainColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),
                                    label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),
                                    label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.account_box),
                                    label: '')
        ],
      ),
    );
    // buildHome(context);
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 100,
      backgroundColor: mainColor,
      leadingWidth: 100,
      leading:Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu, size: Dimensions.width90),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                  print("object");
                },
              );
            },
          ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: Dimensions.width20),
          child: GestureDetector(
              child: IconButton(
                                  icon: Icon(Icons.shopping_cart_outlined, size: Dimensions.iconSize30,), 
                                  color: textColor,
                                  onPressed: () { 
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => CartScreen()));
                                   },
                                  ),
                    onTap: (() {
                          setState(() {
                            value == 0 ? value = 1 : value = 0;
                          });
                        }))
                )
      ],
    );
  }

  Widget _drawerView(Size _screenSize, BuildContext context) {
    return Stack(
    children: [
       Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
                greyColor,
                mainColor,
                mainColor
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter
          )
        ),
       ),
       SafeArea(
        child: Container(
          width: 200,
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: Dimensions.radius40,
                      backgroundColor: textColor,
                      child: Container(
                          child: Icon(
                            Icons.person,
                            size: Dimensions.iconSize80,
                            color: greyColor,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: textColor,
                          ),
                        ),
                        
                      // backgroundImage: Icon(Icons.person),
                    ),
                    SizedBox(height: Dimensions.height10,),
                    Text(username,
                      style: TextStyle(
                        color: textColor,
                        fontSize: Dimensions.font20
                        ),
                    ),
                  ],
                )
              ),
              Expanded(
                  child: ListView(
                      children: [
                            ListTile(
                              onTap: (){
                                //  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Home()));
                                //  Get.to(Home(), transition: Transition.rightToLeftWithFade);
                                 Get.to(() => Home(), transition: Transition.rightToLeftWithFade);
                              },
                              leading: Icon(Icons.home, color: textColor,),
                              title: Text("Home", style: TextStyle(color: textColor),),
                            ),
                            ListTile(
                              onTap: (){
                                //  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Profile()));
                                  // Get.to(MyOrders(), transition: Transition.rightToLeftWithFade);
                                  Get.to(() => MyOrders(), transition: Transition.rightToLeftWithFade);
                                  
                              },
                              leading: Icon(
                                Icons.person, 
                                color: textColor,),
                              title: Text(
                                "My Orders", 
                                style: TextStyle(
                                  color: textColor),),
                            ),
                            ListTile(
                              onTap: (){
                                //  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Profile()));
                                  //Get.to(Profile(), transition: Transition.rightToLeftWithFade);
                                  Get.to(() => Profile(), transition: Transition.rightToLeftWithFade);
                              },
                              leading: Icon(
                                Icons.person, 
                                color: textColor,),
                              title: Text(
                                "Profile", 
                                style: TextStyle(
                                  color: textColor),),
                            ),
                            // ListTile(
                            //   onTap: (){
                            //     //  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Setting()));
                            //      Get.to(Setting(), transition: Transition.rightToLeftWithFade);
                            //   },
                            //   leading: Icon(
                            //         Icons.settings, 
                            //         color: textColor,),
                            //   title: Text(
                            //             "Settings", 
                            //             style: TextStyle(
                            //                 color: textColor),),
                            // ),
                            ListTile(
                            
                              leading: Icon(isLoggedIn?
                                    Icons.logout : Icons.login, 
                                    color: textColor,),
                             
                              title: Text(isLoggedIn ? 'Logout' : 'Login/ Sign Up',  style: TextStyle(
                                             color: textColor),),
                              onTap: () {
                                if (isLoggedIn) {
                                  logout();
                                } else {
                                  // Handle login
                                  login();
                                }
                              },
                            )
                          ],
                        )
                  ),
              ]
            ),
        )
        ),

      //  TweenAnimationBuilder(
      //     tween: Tween<double>(begin: 0,end: value), 
      //     duration: Duration(milliseconds: 200), 
      //     curve: Curves.easeIn,
      //     builder: (_, double val,__){
      //       return (Transform(
      //         alignment: Alignment.center,
      //         transform: Matrix4.identity()
      //         ..setEntry(3, 2, 0.001)
      //         ..setEntry(0, 3 , 200 * val)
      //         ..rotateY((pi / 6) * val),
      //         child: buildHome(context)
      //       ));
      //     }
      //     ),
          // GestureDetector(
          //   onHorizontalDragUpdate: (e){
          //                if (e.delta.dx >0) {
          //                  setState(() {
          //                    value = 1;
          //                  });
          //                }
          //                else{
          //                  setState(() {
          //                    value = 0;
          //                  });
          //                }
          //             },
          // )
    ],
  );
  }

  Scaffold buildHome(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea(
      child: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(top: Dimensions.width20,),
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  EventBody(),
                 
                  HomeCard(),
                         
                ],
              ),
            )
          ],
        ),
      )),
  );
  }

}

class CircleTabIndicator extends Decoration{
  late final BoxPainter _painter;
  CircleTabIndicator({required Color color, required double radius}):_painter= _CirclePainter(color,radius);
  @override
  BoxPainter createBoxPainter([ VoidCallback? onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter{
    late final Paint _paint;
    late double radius;
    _CirclePainter(Color color, this.radius): _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

    @override
    void paint(Canvas canvas, Offset offset, ImageConfiguration configuration){
          final Offset circleOffset = offset + Offset(configuration.size!.width / 2, configuration.size!.height - radius);
          canvas.drawCircle(circleOffset, radius, _paint);
    }
}