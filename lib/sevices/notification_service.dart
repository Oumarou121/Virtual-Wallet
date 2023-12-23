// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationService {
//   static void initialize() {
//     //for ios and web
//     FirebaseMessaging.instance.requestPermission();

//     FirebaseMessaging.onMessage.listen((event) {
//       print('A new onMessage event was published!');
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessage event was published!');
//     });
//   }

//   static Future<String?> getToken() async {
//     return FirebaseMessaging.instance.getToken(
//         vapidKey:
//             "BNBObvfA7A4ZBk1CcYaC1CzMJipgHdFndwnH-RAWLdrFfLIXwmUe9e8k3H2xWG9Cp75jC3rm_rJ-Ah_bNsvqe7k");
//   }
// }
