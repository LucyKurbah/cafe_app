import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'components/colors.dart';
import 'main.dart';

class NotificationServices{
   FirebaseMessaging messaging = FirebaseMessaging.instance;
   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async{
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true
      );

      if(settings.authorizationStatus == AuthorizationStatus.authorized)
      {
          print("User granted Permission");
      }else if(settings.authorizationStatus == AuthorizationStatus.authorized){
          print("User granted provisional Permission");  
      }
      else{
          AppSettings.openAppSettings();
          print("User denied Permission");
      }
  }
   

  void firebaseInit()
  {
      FirebaseMessaging.onMessage.listen((message) {
        if(kDebugMode)
        {
           print(message.notification!.title.toString());
           print("Firebase Title Above__________");
        }
        
         showNotification(message);
    });
  }

  Future<String> getDeviceToken() async{
      String? token = await messaging.getToken();
      return token!;
  }

  void initLocalNotifications(BuildContext context, RemoteMessage message) async{
      var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
      var iosInitializationSettings = const DarwinInitializationSettings();
      var initializationSettings = InitializationSettings(
              android: androidInitializationSettings,
              iOS: iosInitializationSettings
           );
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (payload){

        }
      );

  }

  Future<void> showNotification(RemoteMessage message) async{

      AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Importance Notification',
        importance: Importance.max,
        playSound: true
      );

      AndroidNotificationDetails androidNotificationDetails =     AndroidNotificationDetails(
        channel.id.toString(), 
        channel.name.toString(),
        channelDescription: 'Channel Description',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'Ticker'
      );

     DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
     );

     NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
     );
      Future.delayed(
        Duration.zero, (){
             _flutterLocalNotificationsPlugin.show(
                  0, 
                  message.notification!.title.toString(), 
                  message.notification!.body.toString(), 
                  notificationDetails
              );
          
        }
      );
  }
}