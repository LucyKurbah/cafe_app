import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/screens/onboard/onboard_screen.dart';
import 'package:cafe_app/screens/orders/my_orders.dart';
import 'package:cafe_app/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cafe_app/screens/menu/menu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/dependency_injection.dart';
import 'controllers/home_controller.dart';
import 'screens/table/table_page.dart';
import 'screens/cart/cartscreen.dart';
import 'screens/conference/conference_screen.dart';
import 'screens/home/loading.dart';
import 'package:get/get.dart';
import 'screens/user/login.dart';
import 'screens/user/register.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', //id
    'High Importance Notifications', //title
    // 'This channel is used fro important notifications', //desc
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Message : ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  final pref = await SharedPreferences.getInstance();
  final showHome = pref.getBool('showHome') ?? false;
  runApp(MyApp(showHome: showHome));
  DependencyInjection.init();
}

class MyApp extends StatefulWidget {
  final bool showHome;
  const MyApp(
    {Key? key,
      required this.showHome
    }) : super(key:key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _counter = 0;
  
  @override
  void initState() {
    super.initState();
    saveDeviceTokenIdToSharedPreferences();
    FirebaseMessaging.instance.getInitialMessage();
    //Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print(message.notification!.body);
        print(message.notification!.title);
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    color: blueColor,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("A new onMessageOpenedApp event was publiched!");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body.toString())],
                ),
              );
            });
      }
    });
  }

  Future<void> saveDeviceTokenIdToSharedPreferences() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? deviceTokenId = await messaging.getToken();
    print("DEVICE TOKEN ID IS");
    print(deviceTokenId);
  }

  void incrementCounter() {
    setState(() {
      _counter++;
    });
  }


  void showNotification() {
    setState(() {
      _counter++;
    });

    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doin?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                color: blueColor,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: Builder(builder: (BuildContext context) {
        return GetMaterialApp(
          title: 'Cafe App',
          home: widget.showHome ? const SplashScreen() : const OnboardScreen(),
          routes: {
            '/table': (context) => const TablePage(),
            '/conference': (context) => const ConferenceScreen(),
            '/coffee': (context) => const MenuPage(),
            '/floor': (context) => const MenuPage(),
            '/cart': (context) => const CartScreen(),
            '/checkout': (context) => const CartScreen(),
            '/profile': (context) => const CartScreen(),
            '/login': (context) => const Login(),
            '/signup': (context) => const Register(),
            '/orders': (context) => const MyOrders(),
          },
        );
      }),
    );
  }
}
