// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/authentication/login_screen.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:virtual_wallet_2/sevices/authentication.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class ProfileInfo extends StatefulWidget {
  ProfileInfo({
    super.key,
  });

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  final AuthenticationService _auth = AuthenticationService();

  _lancerAppel({required String PhoneNumber}) async {
    final Uri launchUri = Uri(scheme: 'tel', path: PhoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Impossible d\'appeller $launchUri';
    }
  }

  _lancerEmail({required String PhoneNumber}) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: PhoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Impossible de texter $launchUri';
    }
  }

  _lancerWeb({required String PhoneNumber}) async {
    final Uri launchUri = Uri(scheme: 'https', path: PhoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Impossible de texter $launchUri';
    }
  }

  Widget ImageProfile({required userData}) {
    return CircleAvatar(
      radius: 90,
      backgroundColor: SwicthColorSecondary(userData: userData),
      backgroundImage: AssetImage("images/img_register.png"),
    );
  }

  Widget Call({required userData}) {
    return GestureDetector(
      onTap: () {
        _lancerAppel(PhoneNumber: '+22798663248');
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: SwicthColorSecondary(userData: userData)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.call),
            SizedBox(width: 15),
            Text('+227 98663248', style: TextStyle(fontSize: 20))
          ],
        ),
      ),
      // child: TextFormField(strutStyle: StrutStyle(),
      //   enabled: false,
      //   initialValue: '                 +227 98663248',
      //   decoration: InputDecoration(
      //       border: OutlineInputBorder(), prefixIcon: Icon(Iconsax.call)),
      // ),
    );
  }

  Widget Email({required userData}) {
    return GestureDetector(
      onTap: () {
        _lancerEmail(PhoneNumber: 'virtualwallet@gmail.com');
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: SwicthColorSecondary(userData: userData)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email_outlined),
            SizedBox(width: 15),
            Text('virtualwallet@gmail.com', style: TextStyle(fontSize: 20))
          ],
        ),
      ), // child: TextFormField(
      //   enabled: false,
      //   textCapitalization: TextCapitalization.words,
      //   initialValue: 'oumaroumamodou123@gmail.com',
      //   decoration: InputDecoration(
      //       border: OutlineInputBorder(),
      //       prefixIcon: Icon(Icons.email_outlined)),
      // ),
    );
  }

  Widget Web({required userData}) {
    return GestureDetector(
      onTap: () {
        _lancerWeb(PhoneNumber: 'wwww.virtualwallet.com');
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: SwicthColorSecondary(userData: userData)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.web_outlined),
            SizedBox(width: 15),
            Text(
              'wwww.virtualwallet.com',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
      // child: TextFormField(
      //   enabled: false,
      //   textCapitalization: TextCapitalization.words,
      //   initialValue: '           wwww.virtualwallet.com',
      //   decoration: InputDecoration(
      //       border: OutlineInputBorder(), prefixIcon: Icon(Icons.web_outlined)),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // NotificationService.initialize();
    final user = Provider.of<AppUser?>(context);
    if (user == null) return LoginScreen(userData: null);
    final database = DatabaseService(user.uid);
    return Scaffold(
      appBar: AppBar(
        // title: Text(

        //   'Moi',
        //   style: TextStyle(color: Colors.black),
        // ),
        // centerTitle: true,
        leading: IconButton(
          onPressed: () {
            wPushReplaceTo2(context, BankApp(index: 2));
          },
          icon: Icon(
            Iconsax.back_square,
            color: Colors.black,
          ),
        ),
        actions: [
          Center(
            child: Text(
              'Déconnection',
              style: TextStyle(color: Colors.black),
            ),
          ),
          IconButton(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(
                Iconsax.login,
                color: Colors.black,
              )),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: StreamProvider<AppUserData?>.value(
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
                        child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 14,
                              ),
                              ImageProfile(userData: userData),
                              SizedBox(height: 50),
                              Text(
                                'Bonjour ${userData.name},',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text('En quoi puis-je vous aidez?'),
                              SizedBox(height: 50),
                              Call(userData: userData),
                              SizedBox(height: 40),
                              Email(userData: userData),
                              SizedBox(height: 40),
                              Web(userData: userData),
                            ],
                          ),
                        ),
                      ),
                    )),
                  );
                } else {
                  return Loading();
                }
              })),
    );
  }
}
