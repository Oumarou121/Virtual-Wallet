import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_wallet_2/screens/home/abonnements/Canal.dart';
import 'package:virtual_wallet_2/screens/home/abonnements/CanalConfirm.dart';
import 'package:virtual_wallet_2/utils/utils.dart';

import '../../../widgets/widgets.dart';

// ignore: must_be_immutable
class CanalType extends StatefulWidget {
  CanalType(
      {super.key, this.ID, required this.userData, required this.return1});
  var ID;
  var userData;
  final bool return1;
  @override
  State<CanalType> createState() => _SendIDState();
}

class _SendIDState extends State<CanalType> {
  // ignore: unused_field
  TextEditingController _PlayerID = TextEditingController();
  String qrCode = '';
  String error = '';

  Widget _SendID({required userData}) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Center(
        child: Column(
          children: [
            _input11000(userData: userData),
            const SizedBox(height: 20),
            _input22000(userData: userData),
            const SizedBox(height: 20),
            _input44000(userData: userData)
          ],
        ),
      ),
    );
  }

  Widget _input11000({required userData}) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            wPushReplaceTo2(
                context,
                CanalConfirm(
                  ID: widget.ID,
                  Amount: 11000,
                ));
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(SwicthColor(userData: userData)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: const Text("11000"),
        ));
  }

  Widget _input22000({required userData}) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            wPushReplaceTo2(
                context,
                CanalConfirm(
                  ID: widget.ID,
                  Amount: 22000,
                ));
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(SwicthColor(userData: userData)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: const Text("22000"),
        ));
  }

  Widget _input44000({required userData}) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            wPushReplaceTo2(
                context,
                CanalConfirm(
                  ID: widget.ID,
                  Amount: 44000,
                ));
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(SwicthColor(userData: userData)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: const Text("44000"),
        ));
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
                  'CanalType+',
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
                onPressed: () {
                  if (widget.return1 == false) {
                    wPushReplaceTo2(
                        context,
                        Canal(
                          return1: true,
                          userData: userData,
                        ));
                  } else {
                    wPushReplaceTo2(
                        context,
                        Canal(
                          return1: true,
                          userData: userData,
                        ));
                  }
                }))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _SendID(userData: widget.userData),
              const SizedBox(height: 10),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 24),
              )
            ],
          ),
        ),
      )),
    );
  }
}
