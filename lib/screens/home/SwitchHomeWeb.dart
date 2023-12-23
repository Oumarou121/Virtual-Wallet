// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/security/WebHome.dart';
import 'package:virtual_wallet_2/sevices/database.dart';

class BankAppWeb extends StatefulWidget {
  BankAppWeb({super.key});

  @override
  State<BankAppWeb> createState() => _BankAppWebState();
}

class _BankAppWebState extends State<BankAppWeb> {
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) throw Exception("user not found");
    final database = DatabaseService(user.uid);
    return StreamProvider<AppUserData?>.value(
        value: database.user,
        initialData: null,
        child: StreamBuilder<AppUserData>(
            stream: database.user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                AppUserData? userData = snapshot.data;
                if (userData == null) return Loading();
                return Scaffold(
                    body: SafeArea(
                        child: Stack(
                  children: [WebHome()],
                )));
              } else {
                return Loading();
              }
            }));
  }
}
