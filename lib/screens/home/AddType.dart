import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/Receive.dart';
import 'package:virtual_wallet_2/screens/home/Retrait.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class AddType extends StatefulWidget {
  AddType({super.key, required this.userData});
  var userData;
  @override
  State<AddType> createState() => _AddTypeState();
}

class _AddTypeState extends State<AddType> {
  Widget _SendID({required String IdS}) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Center(
        child: Column(
          children: [
            _inputRecharge(IdS: IdS, userData: widget.userData),
            const SizedBox(height: 20),
            _inputRetrait(IdS: IdS, userData: widget.userData)
          ],
        ),
      ),
    );
  }

  Widget _inputRecharge({required String IdS, required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          wPushReplaceTo2(context, Receive());
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
        child: Text('Recharge'),
      ),
    );
  }

  Widget _inputRetrait({required String IdS, required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          wPushReplaceTo2(context, Retrait(MyUid: IdS));
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
        child: Text(
            SwicthLangues(userData: userData, fr: 'Retrait', en: 'Revocation')),
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
                  SwicthLangues(userData: userData, fr: 'Action', en: 'Action'),
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
                  )),
            ))
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
