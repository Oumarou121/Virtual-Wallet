import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/firebase_options.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/sevices/authentication.dart';
import 'package:virtual_wallet_2/splash.dart';
import 'package:virtual_wallet_2/splashWeb.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Background message ${message.messageId}');
// }

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //       options: FirebaseOptions(
  //           apiKey: "AIzaSyCq8aO67UaO79T3kmP-8te7DQmOEclejuc",
  //           authDomain: "my-virtual-wallet-5f4d7.firebaseapp.com",
  //           projectId: "my-virtual-wallet-5f4d7",
  //           storageBucket: "my-virtual-wallet-5f4d7.appspot.com",
  //           messagingSenderId: "793314480218",
  //           appId: "1:793314480218:web:1412f4b9496da62f8c8863",
  //           measurementId: "G-BLJBC7JGVW"));
  // } else {
  //   await Firebase.initializeApp();
  // }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // ConnectivityPlusService().initConnectivityService();
  // await FirebaseMessaging.instance.getInitialMessage();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

// Future initialization(BuildContext? context) async {
//   ///Load resourcesa²
//   await Future.delayed(const Duration(seconds: 3));
// }
class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthenticationService().user,
      initialData: null,
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        debugShowCheckedModeBanner: false,
        home: kIsWeb ? SplashScreenWrapperWeb() : SplashScreenWrapper(),
      ),
    );
  }
}
