import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:custom_pin_screen/custom_pin_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/authentication/login_screen.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:virtual_wallet_2/screens/security/CodePin%202.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class CodePin extends StatefulWidget {
  // ignore: non_constant_identifier_names, prefer_typing_uninitialized_variables
  var Password;
  CodePin({
    super.key,
    // ignore: non_constant_identifier_names
    this.Password,
  });

  @override
  State<CodePin> createState() => _CodePinState();
}

class _CodePinState extends State<CodePin> {
  Color Custom = Colors.indigo;
  var size = 45.0;
  final LocalAuthentication auth = LocalAuthentication();
  // ignore: unused_field
  bool? _canCheckBiometrics;
  // ignore: unused_field
  String _authorized = 'Not Authorized';
  // ignore: unused_field
  bool _isAuthenticating = false;

  Future<void> _checkBiometrics({required userData}) async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      wShowToast(SwicthLangues(
          userData: userData,
          fr: "La Confirmation Biometrique n\'est pas disponible",
          en: 'Biometrics is unavailable by with phone'));
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
    _authenticateWithBiometrics(userData: userData);
  }

  Future<void> _authenticateWithBiometrics({required userData}) async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: SwicthLangues(
            userData: userData,
            fr: 'Scannez votre empreinte digitale (ou votre visage pour vous authentifier)',
            en: 'Scan your fingerprint (or face or whatever) to authenticate'),
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
        if (authenticated = true) {
          print('yes');
        } else {
          print('no');
        }
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
        // wShowToast('Too many failed attempts. Please try again later');
        wShowToast("${e.message}");
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
    // ConnectivityPlusCustomWidget(
    //   customWidget: const Center(
    //     child: Icon(
    //       Icons.wifi_off_outlined,
    //       color: Colors.red,
    //       size: 100,
    //     ),
    //   ),
    // );

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
                              wPushReplaceTo1(context, CodePin2());
                            }
                          },
                          onSpecialKeyTap: () {
                            _checkBiometrics(userData: userData);
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
                              wPushReplaceTo1(context, CodePin2());
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
}
