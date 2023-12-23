// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:custom_pin_screen/custom_pin_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_wallet_2/screens/authentication/login_screen.dart';
import 'package:virtual_wallet_2/screens/security/ConfirmPinCode.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class CreatePinCode extends StatefulWidget {
  CreatePinCode({super.key, required this.userData});
  var userData;
  @override
  State<CreatePinCode> createState() => _CreatePinCodeState();
}

class _CreatePinCodeState extends State<CreatePinCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: DefaultSelectionStyle.defaultColor,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  wPushReplaceTo1(
                      context, LoginScreen(userData: widget.userData));
                },
                icon: Icon(
                  Iconsax.login,
                  color: Colors.black,
                ))
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: Content(userData: widget.userData));
  }

  Widget Content({required userData}) {
    return PinAuthentication(
      action: SwicthLangues(
          userData: userData, fr: 'Créer Code Pin', en: 'Create Pin Code'),
      actionDescription: SwicthLangues(
          userData: userData,
          fr: 'Ce Code Pin sera indispensable pour se connecter',
          en: 'This password will be required at each login'),
      maxLength: 4,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        backgroundColor: DefaultSelectionStyle.defaultColor,
        keysColor: SwicthColor(userData: userData),
        activeFillColor: SwicthColor(userData: userData),
        selectedFillColor: Color.fromARGB(116, 28, 63, 102),
        inactiveFillColor: Colors.black26,
        fieldWidth: 45,
        fieldHeight: 45,
        borderWidth: 1,
      ),
      onChanged: (v) {},

      onCompleted: (v) {
        if (v.length == 4) {
          wPushReplaceTo2(
              context,
              ConfirmPinCode(
                Password: v,
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
    );
  }
}
