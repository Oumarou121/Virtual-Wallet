import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:virtual_wallet_2/screens/home/history/HistoryAgence.dart';
import 'package:virtual_wallet_2/screens/home/history/HistoryReceive.dart';
import 'package:virtual_wallet_2/screens/home/history/HistoryRecharge.dart';
import 'package:virtual_wallet_2/screens/home/history/HistoryRetrait.dart';
import 'package:virtual_wallet_2/screens/home/history/HistorySend.dart';
import 'package:virtual_wallet_2/screens/home/history/HistoryTransactions.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class HistoryType extends StatefulWidget {
  HistoryType({super.key, required this.ID, required this.userData});
  var ID;
  var userData;
  @override
  State<HistoryType> createState() => _SendIDState();
}

class _SendIDState extends State<HistoryType> {
  // ignore: unused_field
  TextEditingController _PlayerID = TextEditingController();
  String qrCode = '';
  String error = '';
  late List<Map<String, dynamic>> items;
  bool isLoaded = false;

  // ignore: unused_element
  _incrementCounter({required collection}) async {
    List<Map<String, dynamic>> tempsList = [];
    var data = await collection.get();

    data.docs.forEach((element) {
      tempsList.add(element.data());
      setState(() {
        items = tempsList;
        isLoaded = true;
      });
    });
  }

  Widget _SendID({required userData}) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Center(
        child: Column(
          children: [
            _inputSend(userData: userData),
            const SizedBox(height: 20),
            _inputReceive(userData: userData),
            const SizedBox(height: 20),
            _inputTransaction(userData: userData),
            const SizedBox(height: 20),
            _inputAgence(userData: userData),
            const SizedBox(height: 20),
            _inputRecharge(userData: userData),
            const SizedBox(height: 20),
            _inputRetrait(userData: userData)
          ],
        ),
      ),
    );
  }

  Widget _inputSend({required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          wPushReplaceTo2(
              context,
              HistorySend(
                MyUid: widget.ID,
                userData: userData,
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
            Text(SwicthLangues(userData: userData, fr: 'Envoyer', en: 'Send')),
      ),
    );
  }

  Widget _inputReceive({required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          wPushReplaceTo2(
              context,
              HistoryReceive(
                MyUid: widget.ID,
                userData: userData,
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
        child: Text(
            SwicthLangues(userData: userData, fr: 'Reception', en: 'Receive')),
      ),
    );
  }

  Widget _inputRecharge({required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          wPushReplaceTo2(
              context,
              HistoryRecharge(
                MyUid: widget.ID,
                userData: userData,
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
        child: Text('Recharge'),
      ),
    );
  }

  Widget _inputRetrait({required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          wPushReplaceTo2(
              context,
              HistoryRetrait(
                MyUid: widget.ID,
                userData: userData,
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
        child: Text(
            SwicthLangues(userData: userData, fr: 'Retrait', en: 'Revocation')),
      ),
    );
  }

  Widget _inputTransaction({required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          wPushReplaceTo2(
              context,
              HistoryTransactions(
                MyUid: widget.ID,
                userData: userData,
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
        child: const Text("Transactions"),
      ),
    );
  }

  Widget _inputAgence({required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          wPushReplaceTo2(
              context,
              HistoryAgence(
                userData: userData,
                MyUid: widget.ID,
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
            Text(SwicthLangues(userData: userData, fr: 'Agence', en: 'Agency')),
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
                  SwicthLangues(
                      userData: userData, fr: 'Historique', en: 'History'),
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
                onPressed: () => wPushReplaceTo2(context, BankApp(index: 0))))
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
              _top(userData: widget.userData),
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
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
