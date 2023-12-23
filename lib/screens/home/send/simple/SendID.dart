import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_wallet_2/screens/home/send/AchatType.dart';
import 'package:virtual_wallet_2/screens/home/send/simple/SendQrCode.dart';
import 'package:virtual_wallet_2/screens/home/send/simple/SendAmount.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class SendID extends StatefulWidget {
  SendID({super.key, required this.userData, required this.return1});
  var userData;
  final bool return1;
  @override
  State<SendID> createState() => _SendIDState();
}

class _SendIDState extends State<SendID> {
  TextEditingController _PlayerID = TextEditingController();
  String qrCode = '';
  String error = '';

  Widget _SendID({required userData}) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Center(
        child: Column(
          children: [
            Container(child: _imputPlayerID(userData: userData)),
            const SizedBox(height: 20),
            _qrCode(userData: userData),
            const SizedBox(height: 20),
            _inputConfirm(userData: userData)
          ],
        ),
      ),
    );
  }

  Widget _imputPlayerID({required userData}) {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        controller: _PlayerID,
        decoration: InputDecoration(
            hintText:
                SwicthLangues(userData: userData, fr: 'Son Uid', en: 'Her ID'),
            helperText: SwicthLangues(
                userData: userData,
                fr: 'Entre l\'ID Conplet',
                en: 'Entert Full ID'),
            border: OutlineInputBorder(),
            prefixIcon: Icon(Iconsax.creative_commons)),
      ),
    );
  }

  Widget _inputConfirm({required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          var collection = FirebaseFirestore.instance.collection("users");
          // var allDocs = await collection.get();
          // var docID = allDocs.docs.last.id;
          var num = await collection
              .where("playerUid", isEqualTo: _PlayerID.text)
              .get();
          if (num.size == 1) {
            wPushReplaceTo2(
                context,
                SendAmount(
                  UidR: _PlayerID.text,
                  userData: widget.userData,
                  return1: false,
                ));
          } else {
            setState(() {
              error = SwicthLangues(
                  userData: userData,
                  fr: 'Aucun utilisatuer trouver',
                  en: 'No User Found');
            });
          }
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
            SwicthLangues(userData: userData, fr: 'Confirmer', en: 'Confirm')),
      ),
    );
  }

  Widget _top() {
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
                  SwicthLangues(
                      userData: widget.userData, fr: 'Achats', en: 'Purchases'),
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
                        context, AchatType(userData: widget.userData));
                  } else {
                    wPushReplaceTo2(
                        context, AchatType(userData: widget.userData));
                  }
                }))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              _top(),
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

  Widget _qrCode({required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(SwicthLangues(
                userData: userData, fr: 'Scanner', en: 'To Scan')),
            SizedBox(width: 10),
            Icon(Icons.qr_code)
          ],
        ),
        onPressed: () => Navigator.push(
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
            )),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(SwicthColor(userData: widget.userData)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
