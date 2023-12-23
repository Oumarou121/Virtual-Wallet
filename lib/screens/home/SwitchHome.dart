import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/Internet.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/Home.dart';
import 'package:virtual_wallet_2/screens/home/Profile.dart';
import 'package:virtual_wallet_2/screens/home/Transactions.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';

// ignore: must_be_immutable
class BankApp extends StatefulWidget {
  BankApp({super.key, required int this.index});
  int index;
  @override
  State<BankApp> createState() => _BankAppState();
}

class _BankAppState extends State<BankApp> {
  int index = 0;
  PageController controller = PageController(initialPage: 0);
  bool hideUi = false;
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

  DateTime timeBackPressed = DateTime.now();
  @override
  void initState() {
    super.initState();
    setState(() {
      index = widget.index;
      controller = PageController(initialPage: widget.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) throw Exception("user not found");
    final database = DatabaseService(user.uid);

    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= Duration(seconds: 2);
        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          final message = 'Press back again to exit';
          Fluttertoast.showToast(msg: message, fontSize: 18);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: FutureBuilder(
        future: _Conncetion(),
        builder: (context, snapshot) => StreamProvider<AppUserData?>.value(
            value: database.user,
            initialData: null,
            child: StreamBuilder<AppUserData>(
                stream: database.user,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    AppUserData? userData = snapshot.data;
                    if (userData == null) return Loading();
                    return hideUi
                        ? Internet()
                        : Scaffold(
                            body: SafeArea(
                                child: Stack(
                            children: [
                              PageView(
                                onPageChanged: (value) {
                                  setState(() {
                                    index = value;
                                  });
                                },
                                controller: controller,
                                children: [
                                  Home(
                                    MyUid: user.uid,
                                  ),
                                  Transactions(),
                                  Profile()
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: FloatingNavbar(
                                  onTap: (i) {
                                    setState(() {
                                      index = i;
                                      controller.jumpToPage(index);
                                    });
                                  },
                                  currentIndex: index,
                                  borderRadius: 30,
                                  iconSize: 26,
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(12),
                                  selectedBackgroundColor: Colors.transparent,
                                  selectedItemColor: Colors.white,
                                  unselectedItemColor: Colors.white70,
                                  backgroundColor:
                                      SwicthColor(userData: userData),
                                  items: [
                                    FloatingNavbarItem(icon: Iconsax.home),
                                    FloatingNavbarItem(
                                        icon: Iconsax.money_change4),
                                    // FloatingNavbarItem(icon: Iconsax.arrow_down_24),
                                    FloatingNavbarItem(icon: Iconsax.setting)
                                  ],
                                ),
                              ),
                            ],
                          )));
                  } else {
                    return Loading();
                  }
                })),
      ),
    );
  }
}
