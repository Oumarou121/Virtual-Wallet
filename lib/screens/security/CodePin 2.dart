import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
// import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:custom_pin_screen/custom_pin_screen.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/authentication/login_screen.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:virtual_wallet_2/screens/security/CodePin%201.dart';
import 'package:virtual_wallet_2/screens/security/Forgot_PinCode.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class CodePin2 extends StatefulWidget {
  const CodePin2({super.key});

  @override
  State<CodePin2> createState() => _CodePin2State();
}

class _CodePin2State extends State<CodePin2> {
  Color Custom = Colors.indigo;
  var size = 45.0;
  final LocalAuthentication auth = LocalAuthentication();
  // ignore: unused_field
  bool? _canCheckBiometrics;
  // ignore: unused_field
  String _authorized = 'Not Authorized';
  // ignore: unused_field
  bool _isAuthenticating = false;

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      wShowToast('Biometrics is unavailable by with phone');
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
    _authenticateWithBiometrics();
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
        if (authenticated = true) {
          wPushReplaceTo1(context, BankApp(index: 0));
        } else {}
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
        wShowToast('Too many failed attempts. Please try again later');
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  @override
  Widget build(BuildContext context) {
// ignore: unused_local_variable
    bool onClick = false;
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
                            wPushReplaceTo1(
                                context,
                                LoginScreen(
                                  userData: userData,
                                ));
                          },
                          icon: Icon(
                            Iconsax.login,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  resizeToAvoidBottomInset: true,
                  body: userData.DBiometrique
                      ? PinAuthentication(
                          action: SwicthLangues(
                              userData: userData,
                              fr: 'Entre votre Code Pin',
                              en: 'Enter Pin Code'),
                          actionDescription: SwicthLangues(
                              userData: userData,
                              fr: 'Veillez entre votre Code Pin pour continuer',
                              en: 'Please Enter your Pin Code to continue'),
                          maxLength: 4,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            backgroundColor: DefaultSelectionStyle.defaultColor,
                            keysColor: SwicthColor(userData: userData),
                            activeFillColor: SwicthColor(userData: userData),
                            selectedFillColor:
                                SwicthColorSecondary(userData: userData),
                            inactiveFillColor: Colors.black26,
                            fieldWidth: size,
                            fieldHeight: size,
                            borderWidth: 1,
                          ),
                          onChanged: (value) {},
                          onCompleted: (value) async {
                            if (value == userData.password) {
                              wPushReplaceTo1(context, BankApp(index: 0));
                            }
                            if (value != userData.password) {
                              setState(() {
                                Custom = Colors.red;
                                size = 50.0;
                              });
                              Vibration.vibrate(duration: 100);
                              await Future.delayed(Duration(seconds: 1));
                              setState(() {
                                Custom =
                                    SwicthColorSecondary(userData: userData);
                                size = 45.0;
                              });
                              Succes(userData: userData);
                            }
                          },
                          onSpecialKeyTap: () {
                            _checkBiometrics();
                          },
                          // specialKey: const SizedBox(),
                          useFingerprint: true,
                        )
                      : PinAuthentication(
                          action: SwicthLangues(
                              userData: userData,
                              fr: 'Entre votre Code Pin',
                              en: 'Enter Pin Code'),
                          actionDescription: SwicthLangues(
                              userData: userData,
                              fr: 'Veillez entre votre Code Pin pour continuer',
                              en: 'Please Enter your Pin Code to continue'),
                          maxLength: 4,

                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            backgroundColor: DefaultSelectionStyle.defaultColor,
                            keysColor: SwicthColor(userData: userData),
                            activeFillColor: SwicthColor(userData: userData),
                            selectedFillColor:
                                SwicthColorSecondary(userData: userData),
                            inactiveFillColor: Colors.black26,
                            fieldWidth: size,
                            fieldHeight: size,
                            borderWidth: 1,
                          ),
                          onChanged: (value) {},
                          onCompleted: (value) async {
                            if (value == userData.password) {
                              wPushReplaceTo1(context, BankApp(index: 0));
                            }
                            if (value != userData.password) {
                              setState(() {
                                Custom = Colors.red;
                                size = 50.0;
                              });
                              Vibration.vibrate(duration: 100);
                              await Future.delayed(Duration(seconds: 1));
                              setState(() {
                                Custom =
                                    SwicthColorSecondary(userData: userData);
                                size = 45.0;
                              });
                              Succes(userData: userData);
                            }
                          },

                          // specialKey: const SizedBox(),
                          useFingerprint: false,
                        ),
                );
              } else {
                return Loading();
              }
            }));
  }

  void Succes({required userData}) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) {
          return _Succes(userData: userData);
        });
  }

  Widget _Succes({required AppUserData userData}) {
    return Container(
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(200))),
        child: Column(
          children: [
            SizedBox(height: 8),
            Text(
              SwicthLangues(userData: userData, fr: 'Code Pin', en: 'Pin Code'),
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 12),
            Text(
              SwicthLangues(
                  userData: userData,
                  fr: "Voulez-vous changer de Code Pin",
                  en: "Do you want to change Pin Code"),
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            IconsButton(
              onPressed: () {
                wPushReplaceTo1(
                    context,
                    Forgot_PinCode(
                      userData: userData,
                    ));
              },
              text: SwicthLangues(userData: userData, fr: 'Oui', en: 'Yes'),
              iconData: Icons.check,
              color: Colors.blue,
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
              shape: StadiumBorder(),
            ),
            SizedBox(height: 8),
            IconsOutlineButton(
              onPressed: () {
                // Navigator.of(context, rootNavigator: true).pop();
                wPushReplaceTo1(
                    context,
                    CodePin(
                      Password: userData.password,
                    ));
              },
              text: SwicthLangues(userData: userData, fr: 'Non', en: 'No'),
              iconData: Icons.cancel_outlined,
              textStyle: TextStyle(color: Colors.grey),
              iconColor: Colors.grey,
              shape: StadiumBorder(),
            ),
          ],
        ));
  }
}
