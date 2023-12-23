import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:virtual_wallet_2/screens/home/send/simple/SendID.dart';
import 'package:virtual_wallet_2/screens/home/send/simple/SendQrCode.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class AchatType extends StatefulWidget {
  AchatType({super.key, this.ID, required this.userData});
  var ID;
  var userData;
  @override
  State<AchatType> createState() => _AchatTypeState();
}

class _AchatTypeState extends State<AchatType> {
  Widget _SendID({required String IdS}) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Center(
        child: Column(
          children: [
            _inputCompte(IdS: IdS, userData: widget.userData),
            const SizedBox(height: 20),
            _inputNumber(IdS: IdS, userData: widget.userData)
          ],
        ),
      ),
    );
  }

  Widget _inputCompte({required String IdS, required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          wPushReplaceTo2(
              context,
              SendID(
                userData: userData,
                return1: false,
              ));
        },
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(SwicthColor(userData: widget.userData)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        child:
            Text(SwicthLangues(userData: userData, fr: 'Carburant', en: 'Gas')),
      ),
    );
  }

  Widget _inputNumber({required String IdS, required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                settings: RouteSettings(),
                pageBuilder: (_, __, ___) => SendQrCode(userData: userData),
                transitionDuration: const Duration(milliseconds: 400),
                transitionsBuilder: (_, animation, __, child) {
                  // slide in transition,
                  // from right (x = 1) to center (x = 0) screen
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ));
        },
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(SwicthColor(userData: widget.userData)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        child: Text(SwicthLangues(
            userData: userData, fr: "Produits Divers", en: 'Diverse Products')),
      ),
    );
  }

  Widget _top({required userData}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '      ',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                ),
                SizedBox(width: 10),
                Text(
                  SwicthLangues(userData: userData, fr: 'Envoyer', en: 'Send'),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
        Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
                icon: Icon(Iconsax.back_square, color: Colors.black),
                iconSize: 24,
                onPressed: () => wPushReplaceTo3(context, BankApp(index: 1))))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // NotificationService.initialize();
    final user = Provider.of<AppUser?>(context);
    if (user == null) throw Exception("user not found");
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              _top(userData: widget.userData),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
              ),
              _SendID(IdS: user.uid),
              const SizedBox(height: 10),
            ],
          ),
        ),
      )),
    );
  }
}
