// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:virtual_wallet_2/screens/home/factures/NigelecConfirm.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class Nigelec extends StatefulWidget {
  Nigelec({super.key, required this.userData, required this.return1});
  var userData;
  final bool return1;

  @override
  State<Nigelec> createState() => _NigelecState();
}

class _NigelecState extends State<Nigelec> {
  TextEditingController _PlayerID = TextEditingController();
  String qrCode = '';
  String error = '';

  Widget _SendID({required userData}) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Center(
        child: Column(
          children: [
            _imputPlayerID(userData: userData),
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
        keyboardType: TextInputType.number,
        controller: _PlayerID,
        decoration: InputDecoration(
            hintText: SwicthLangues(
                userData: userData,
                fr: 'Numéro d\'abonnement',
                en: 'Subscription number'),
            // helperText: 'Entert Full',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Iconsax.creative_commons)),
      ),
    );
  }

  Widget _inputConfirm({required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 64,
      child: ElevatedButton(
        onPressed: () {
          if (_PlayerID.text.length == 14) {
            wPushReplaceTo2(
                context,
                NigelecConfirm(
                  Numero: _PlayerID.text,
                ));
          } else {
            setState(() {
              error = SwicthLangues(
                  userData: userData, fr: 'Invalide', en: 'Invalid');
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
                  'Nigelec',
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
                    wPushReplaceTo3(context, BankApp(index: 1));
                  } else {
                    wPushReplaceTo3(context, BankApp(index: 1));
                  }
                }))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // NotificationService.initialize();
    // final user = Provider.of<AppUser?>(context);
    // if (user == null) throw Exception("user not found");
    // final database = DatabaseService(user.uid);
    // return StreamProvider<AppUserData?>.value(
    //     value: database.user,
    //     initialData: null,
    //     child: StreamBuilder<AppUserData>(
    //         stream: database.user,
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData) {
    //             AppUserData? userData = snapshot.data;
    //             if (userData == null) return Loading();
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
  //  else {
  //   return Loading();
  // }
}
            
//             ));
//   }
// }
