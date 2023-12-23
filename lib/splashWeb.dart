import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/authentication/login_screen.dart';
import 'package:virtual_wallet_2/screens/security/CodePinWeb1.dart';
import 'package:virtual_wallet_2/sevices/database.dart';

class SplashScreenWrapperWeb extends StatefulWidget {
  const SplashScreenWrapperWeb({super.key});

  @override
  State<SplashScreenWrapperWeb> createState() => _SplashScreenWrapperWebState();
}

class _SplashScreenWrapperWebState extends State<SplashScreenWrapperWeb> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) return LoginScreen(userData: null);
    final database = DatabaseService(user.uid);
    return StreamBuilder<AppUserData?>(
        stream: database.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            AppUserData? userData = snapshot.data;
            if (userData == null) return LoginScreen(userData: null);
            return M1(userData: userData);
          }
          return LoginScreen(userData: null);
        });
  }

  Widget M1({required AppUserData userData}) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      // darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: CodePinWeb1(),
    );
  }
}
