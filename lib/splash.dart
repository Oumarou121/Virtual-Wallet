import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/Internet.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/authentication/login_screen.dart';
import 'package:virtual_wallet_2/screens/security/CodePinWeb1.dart';
import 'package:virtual_wallet_2/screens/security/CreatePinCode.dart';
import 'package:virtual_wallet_2/screens/security/CodePin%201.dart';
import 'package:virtual_wallet_2/sevices/database.dart';

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  bool hideUi = true;
  final Connectivity _connectivity = Connectivity();
  _Conncetion() {
    _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        setState(() {
          hideUi = true;
        });
      } else {
        setState(() {
          hideUi = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) return LoginScreen(userData: null);
    final database = DatabaseService(user.uid);
    return FutureBuilder(
      future: _Conncetion(),
      builder: (context, snapshot) => StreamProvider<AppUserData?>.value(
          value: database.user,
          initialData: null,
          child: StreamBuilder<AppUserData>(
              stream: database.user,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  AppUserData? userData = snapshot.data;
                  if (userData == null) return LoginScreen(userData: null);
                  // if (TargetPlatform == windows) {
                  //   return M1Windows(userData: userData);
                  // } else {
                  return userData.autoBrightness
                      ? M1(userData: userData)
                      : userData.isDark
                          ? M2(userData: userData)
                          : M3(userData: userData);
                  // }
                }
                return MaterialApp(
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                    brightness: Brightness.light,
                  ),
                  darkTheme: ThemeData(brightness: Brightness.dark),
                  debugShowCheckedModeBanner: false,
                  home: LoginScreen(userData: null),
                );
              })),
    );
  }

  Widget Content({required userData}) {
    if (userData.password == '') {
      return CreatePinCode(
        userData: userData,
      );
    } else {
      return CodePin(
        Password: userData.password,
      );
    }
  }

  Widget M1Windows({required AppUserData userData}) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      // darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: CodePinWeb1(),
    );
  }

  Widget M1({required AppUserData userData}) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: hideUi ? Internet() : Content(userData: userData),
    );
  }

  Widget M2({required AppUserData userData}) {
    return MaterialApp(
        theme: ThemeData(
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            brightness: Brightness.dark),
        debugShowCheckedModeBanner: false,
        home: hideUi ? Internet() : Content(userData: userData));
  }

  Widget M3({required AppUserData userData}) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            brightness: Brightness.light),
        debugShowCheckedModeBanner: false,
        home: hideUi ? Internet() : Content(userData: userData));
  }
}
