import 'package:flutter/material.dart';
import 'package:custom_pin_screen/custom_pin_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/security/CodePin%201.dart';
import 'package:virtual_wallet_2/screens/security/CreatePinCode.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class ConfirmPinCode extends StatefulWidget {
  ConfirmPinCode({super.key, this.Password, required this.userData});
  var userData;
  var Password;

  @override
  State<ConfirmPinCode> createState() => _ConfirmPinCodeState();
}

class _ConfirmPinCodeState extends State<ConfirmPinCode> {
  var custom = Colors.indigo;
  var size = 45.0;

  @override

  //   final user = Provider.of<User>(context, listen: false);
  //   final userData = Provider.of<AppUserData>(context, listen: false);
  //   final database = DatabaseService(userData.uid);

  //   return Content(user: user, database: database);
  // }

  Widget build(BuildContext context) {
    // NotificationService.initialize();
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
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: DefaultSelectionStyle.defaultColor,
                      elevation: 0,
                      actions: [
                        IconButton(
                            onPressed: () {
                              wPushReplaceTo2(
                                  context,
                                  CreatePinCode(
                                    userData: widget.userData,
                                  ));
                            },
                            icon: Icon(
                              Iconsax.login,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    resizeToAvoidBottomInset: true,
                    body: PinAuthentication(
                      action: SwicthLangues(
                          userData: userData,
                          fr: 'Confirmation du Code Pin',
                          en: 'Confirm Pin Code'),

                      actionDescription: SwicthLangues(
                          userData: userData,
                          fr: 'Ce Code Pin sera indispensable pour se connecter',
                          en: 'This Code Pin will be required at each login'),
                      maxLength: 4,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        backgroundColor: DefaultSelectionStyle.defaultColor,
                        keysColor: SwicthColor(userData: widget.userData),
                        activeFillColor: SwicthColor(userData: widget.userData),
                        selectedFillColor: Color.fromARGB(116, 28, 63, 102),
                        inactiveFillColor: Colors.black26,
                        fieldWidth: size,
                        fieldHeight: size,
                        borderWidth: 1,
                      ),
                      onChanged: (v) {},

                      onCompleted: (v) async {
                        if (v == widget.Password) {
                          await database.saveUser(
                              userData.name,
                              userData.waterCounter,
                              v,
                              userData.passwordSign,
                              userData.playerUid,
                              userData.phone,
                              userData.token,
                              userData.ImageUrl,
                              userData.DBiometrique,
                              userData.CBiometrique,
                              userData.autoBrightness,
                              userData.isDark,
                              userData.primaryColor,
                              userData.langues);

                          wPushReplaceTo2(
                              context,
                              CodePin(
                                Password: v,
                              ));
                        }
                        if (v != widget.Password) {
                          setState(() {
                            custom = Colors.red;
                            size = 50.0;
                          });
                          Vibration.vibrate(duration: 100);
                          await Future.delayed(Duration(seconds: 1));
                          setState(() {
                            size = 45.0;
                          });
                          wPushReplaceTo2(
                              context,
                              CreatePinCode(
                                userData: widget.userData,
                              ));
                        }
                      },

                      onSpecialKeyTap: () {
                        Fluttertoast.showToast(
                          msg: SwicthLangues(
                              userData: userData,
                              fr: 'Indisponible pendant la Creation de Code Pin',
                              en: 'Available after the creation of the Pin Code'),
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          toastLength: Toast.LENGTH_LONG,
                        );
                      },
                      // specialKey: const SizedBox(),
                      useFingerprint: true,
                    ));
              } else {
                return Loading();
              }
            }));
  }
}
