import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/screens/cart/cartscreen.dart';
import 'package:cafe_app/screens/faq/faq_screen.dart';
import 'package:cafe_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import '../../components/dimensions.dart';
import '../../models/user_model.dart';
import '../../services/api_response.dart';
import '../../widgets/custom_widgets.dart';
import '../orders/my_orders.dart';
import 'event_body.dart';
import 'home_card.dart';
import '../user/login.dart';
import '../profile/profile.dart';
import 'package:cafe_app/services/user_service.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController tabController;
  double value = 0;
  String username = '';
  bool isLoggedIn = false;
  RxBool themeMode = true.obs;

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 4, vsync: this);
    getUserDetail();
    super.initState();
  }

  void getUserDetail() async {
    ApiResponse response = await getUserDetails();
    if (response.error == null) {
      UserModel user = response.data as UserModel;
      setState(() {
        username = user.name;
        isLoggedIn = true;
      });
    } else {
      setState(() {
        isLoggedIn = false;
        username = '';
      });
    }
  }

  void login() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) =>const  Login()), (route) => false);
  }

  void logout() {
    logoutUser();
    getUserDetail();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) =>const  HomeScreen()));
    showSnackBar(title: '', message: 'Logged Out');
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(context),
      drawer: Drawer(
        child: _drawerView(screenSize, context),
      ),
      body: buildHome(context),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 100,
      backgroundColor: mainColor,
      leadingWidth: 100,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu, size: Dimensions.width90, color: textColor,),
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
                onTap: (() {
                  setState(() {
                    value == 0 ? value = 1 : value = 0;
                  });
                }),
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    size: Dimensions.iconSize24,
                  ),
                  color: textColor,
                  onPressed: () {
                     Get.to(() =>const CartScreen(),
                        transition: Transition.rightToLeftWithFade);
                  },
                )))
      ],
    );
  }

  Widget _drawerView(Size screenSize, BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [greyColor, mainColor, mainColor],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter)
              ),
        ),
        SafeArea(
          child: Container(
          width: 200,
          padding:const  EdgeInsets.all(8.0),
          child: Column(children: [
            DrawerHeader(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    CircleAvatar(
                      radius: Dimensions.radius40,
                      backgroundColor: textColor,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: textColor,
                        ),
                        child: Icon(
                          Icons.person,
                          size: Dimensions.iconSize80,
                          color: greyColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    Text(
                      username,
                      style:
                          TextStyle(color: textColor, fontSize: Dimensions.font20),
                    ),
                ],
                )
            ),
            Expanded(
                child: ListView(
              children: [
               
                ListTile(
                  onTap: () {
                    
                    Get.to(() =>const  MyOrders(),
                        transition: Transition.rightToLeftWithFade);
                  },
                  leading: Icon(
                    Icons.account_box,
                    color: textColor,
                  ),
                  title: Text(
                    "Orders",
                    style: TextStyle(color: textColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    
                    Get.to(() =>const  FaqScreen(),
                        transition: Transition.rightToLeftWithFade);
                  },
                  leading: Icon(
                    Icons.question_mark,
                    color: textColor,
                  ),
                  title: Text(
                    "FAQs",
                    style: TextStyle(color: textColor),
                  ),
                ),
                ListTile(
                  onTap: () {

                    Get.to(() =>const  Profile(),
                        transition: Transition.rightToLeftWithFade);
                  },
                  leading: Icon(
                    Icons.view_list_outlined,
                    color: textColor,
                  ),
                  title: Text(
                    "Terms of Use",
                    style: TextStyle(color: textColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                   
                    Get.to(() =>const  Profile(),
                        transition: Transition.rightToLeftWithFade);
                  },
                  leading: Icon(
                    Icons.person,
                    color: textColor,
                  ),
                  title: Text(
                    "Privacy Policy",
                    style: TextStyle(color: textColor),
                  ),
                ),
                // ListTile(
                //   leading: Icon(Get.isDarkMode ? Icons.dark_mode : Icons.dark_mode_outlined),
                //   iconColor: textColor,
                //   minLeadingWidth: 20,
                //   title: const Text("Dark Theme", style: TextStyle(color: Colors.white)),
                //   trailing: Switch(
                //     value: themeMode.value,
                //     onChanged: (value) {
                //       Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
                //       themeMode.value = value;
                //     },
                //   ),
                // ),
                ListTile(
                  leading: Icon(
                    isLoggedIn ? Icons.logout : Icons.login,
                    color: textColor,
                  ),
                  title: Text(
                    isLoggedIn ? 'Logout' : 'Login/ Sign Up',
                    style: TextStyle(color: textColor),
                  ),
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
            )),
          ]),
        )),

       
      ],
    );
  }

  Scaffold buildHome(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(
              top: Dimensions.width20,
            ),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const EventBody(),
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

class CircleTabIndicator extends Decoration {
  late final BoxPainter _painter;
  CircleTabIndicator({required Color color, required double radius})
      : _painter = _CirclePainter(color, radius);
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  late final Paint _paint;
  late double radius;
  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Offset circleOffset = offset +
        Offset(
            configuration.size!.width / 2, configuration.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
