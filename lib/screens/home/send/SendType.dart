import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:virtual_wallet_2/screens/home/send/agence/SendAgence.dart';
import 'package:virtual_wallet_2/screens/home/send/number/SendNumber.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class SendType extends StatefulWidget {
  SendType({super.key, this.ID, required this.userData});
  final ID;
  final userData;
  @override
  State<SendType> createState() => _SendTypeState();
}

class _SendTypeState extends State<SendType> {
  Widget _SendType({required String IdS}) {
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
              SendNumber(
                IdS: IdS,
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
        child: Text(SwicthLangues(
            userData: userData,
            fr: 'Compte à Compte',
            en: 'Account to Account')),
      ),
    );
  }

  Widget _inputNumber({required String IdS, required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          wPushReplaceTo2(
              context,
              SendAgence(
                IdS: IdS,
                userData: widget.userData,
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
        child: Text(SwicthLangues(
            userData: userData,
            fr: "Compte à Agence",
            en: 'Account by Agency')),
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
                onPressed: () => wPushReplaceTo2(
                    context,
                    BankApp(
                      index: 0,
                    ))))
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
              SizedBox(height: MediaQuery.of(context).size.height / 3),
              _SendType(IdS: user.uid),
            ],
          ),
        ),
      )),
    );
  }
}
