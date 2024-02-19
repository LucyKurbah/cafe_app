import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices{
   FirebaseMessaging messaging = FirebaseMessaging.instance;

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
   
   Future<String> getDeviceToken() async{
      String? token = await messaging.getToken();
      return token!;
   }
}