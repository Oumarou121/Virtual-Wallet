import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/authentication/login_screen.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:virtual_wallet_2/screens/security/Forgot_PinCode.dart';
import 'package:virtual_wallet_2/sevices/authentication.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class ProfileSecurity extends StatefulWidget {
  ProfileSecurity({super.key, required this.userData});
  var userData;
  @override
  State<ProfileSecurity> createState() => _ProfileSecurityState();
}

class _ProfileSecurityState extends State<ProfileSecurity> {
  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    // NotificationService.initialize();
    final user = Provider.of<AppUser?>(context);
    if (user == null) return LoginScreen(userData: widget.userData);
    final database = DatabaseService(user.uid);
    final CollectionReference<Map<String, dynamic>> userCollection =
        FirebaseFirestore.instance.collection("users");
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
                    appBar: AppBar(
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
                            SwicthLangues(
                                userData: widget.userData,
                                fr: 'Déconnection',
                                en: 'Logout'),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              await _auth.signOut();
                              wPushReplaceTo1(
                                  context,
                                  LoginScreen(
                                    userData: widget.userData,
                                  ));
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
                    body: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: MediaQuery.of(context).size.height / 8),
                        child: Column(
                          children: [
                            DBiometrique(
                                userData: userData,
                                DB: userData.DBiometrique,
                                Uid: user.uid,
                                userCollection: userCollection),
                            SizedBox(height: 30),
                            CBiometrique(
                                userData: userData,
                                CB: userData.CBiometrique,
                                Uid: user.uid,
                                userCollection: userCollection),
                            SizedBox(height: 30),
                            ChCodePin(userData: userData)
                          ],
                        ),
                      ),
                    ));
              } else {
                return Loading();
              }
            }));
  }

  Widget DBiometrique(
      {required DB, required userCollection, required Uid, required userData}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade400,
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('images/print1.png'),
          ),
          Text(
            SwicthLangues(
                userData: userData,
                fr: 'Déverroullage \n biométrique',
                en: 'Biometric \n unlock'),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(width: 20),
          Switch(
            activeColor: SwicthColor(userData: userData),
            value: DB,
            onChanged: (value) async {
              await userCollection.doc(Uid).update({'DBiometrique': value});
            },
          )
        ],
      ),
    );
  }

  Widget CBiometrique(
      {required CB, required userCollection, required Uid, required userData}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade400,
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('images/print1.png'),
          ),
          Text(
            SwicthLangues(
                userData: userData,
                fr: 'Confirmation \n biométrique',
                en: 'Biometric \n Confirmation'),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(width: 20),
          Switch(
            activeColor: SwicthColor(userData: userData),
            value: CB,
            onChanged: (value) async {
              await userCollection.doc(Uid).update({'CBiometrique': value});
            },
          )
        ],
      ),
    );
  }

  Widget ChCodePin({required userData}) {
    return GestureDetector(
      onTap: () {
        wPushReplaceTo1(context, Forgot_PinCode(userData: userData));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade400,
        ),
        height: 70,
        child: Row(
          children: [
            SizedBox(width: 30),
            Icon(Iconsax.code_circle), SizedBox(width: 30),

            Center(
              child: Text(
                SwicthLangues(
                    userData: userData,
                    fr: 'Changer de Code Pin',
                    en: 'Changer Pin Code'),
                style: TextStyle(fontSize: 18),
              ),
            ), // SizedBox(
            //   width: MediaQuery.of(context).size.width,
            //   height: 30,
            //   child: ElevatedButton(
            //     onPressed: () async {},
            //     style: ButtonStyle(
            //       backgroundColor:
            //           MaterialStateProperty.all(Theme.of(context).colorScheme.inversePrimary

            //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //         RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(16),
            //         ),
            //       ),
            //     ),
            //     child: const Text("Changer"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
