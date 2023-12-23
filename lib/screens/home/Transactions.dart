import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/abonnements/Canal.dart';
import 'package:virtual_wallet_2/screens/home/cr%C3%A9dits/Airtel.dart';
import 'package:virtual_wallet_2/screens/home/cr%C3%A9dits/Moov.dart';
import 'package:virtual_wallet_2/screens/home/cr%C3%A9dits/NigerTelecoms.dart';
import 'package:virtual_wallet_2/screens/home/cr%C3%A9dits/Zamani.dart';
import 'package:virtual_wallet_2/screens/home/factures/Nigelec.dart';
import 'package:virtual_wallet_2/screens/home/factures/Seen.dart';
import 'package:virtual_wallet_2/screens/home/send/AchatType.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
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
                  SwicthLangues(userData: userData, fr: 'Mes', en: 'My'),
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                ),
                SizedBox(width: 10),
                Text(
                  'Transactions',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Iconsax.money,
              size: 24,
              color: Colors.black,
            ))
      ]),
    );
  }

  // ignore: unused_element
  Widget _BtnNigelec(iconImagePath, buttonText) {
    return Column(
      children: [
        // icon
        Container(
          height: 90,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.white, blurRadius: 30, spreadRadius: 10)
              ]),
          child: Center(
            child: Image.asset(
              iconImagePath,
            ),
          ),
        ),
        SizedBox(height: 4),
        // text
        Text(
          buttonText,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _Btn(iconImagePath, buttonText, Widget1) {
    return GestureDetector(
      onTap: () {
        wPushReplaceTo5(context, Widget1);
      },
      child: Column(
        children: [
          // icon
          Container(
            height: 90,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  // BoxShadow(
                  //     // color: Colors.white,
                  //     blurRadius: 30,
                  //     spreadRadius: 10)
                ]),
            child: Center(
              child: Image.asset(
                iconImagePath,
              ),
            ),
          ),
          SizedBox(height: 4),
          // text
          Text(
            buttonText,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _Factures({required userData}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          _Btn(
              "images/Nigelec2.png",
              "Nigelec",
              Nigelec(
                userData: userData,
                return1: false,
              )),
          const SizedBox(width: 35),
          _Btn(
              "images/Seen.png",
              "Seen",
              Seen(
                userData: userData,
                return1: false,
              )),
          const SizedBox(width: 35),
          _Btn(
              "images/Gaz.png",
              "Achats",
              AchatType(
                userData: userData,
              )),
        ],
      ),
    );
  }

  Widget _Abonnements({required userData}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          _Btn(
              "images/Canal+.png",
              "Canal+",
              Canal(
                userData: userData,
                return1: false,
              )),
          const SizedBox(width: 35),
          _Btn(
              "images/CanalSat.png",
              "CanalSat",
              Canal(
                userData: userData,
                return1: false,
              )),
        ],
      ),
    );
  }

  Widget _Credits({required userData}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          Row(
            children: [
              _Btn(
                  "images/Airtel.png",
                  "Airtel",
                  Airtel(
                    userData: userData,
                    return1: false,
                  )),
              const SizedBox(width: 35),
              _Btn(
                  "images/Zamani.png",
                  "Zamani",
                  Zamani(
                    userData: userData,
                    return1: false,
                  )),
              const SizedBox(width: 35),
              _Btn(
                  "images/Moov.png",
                  "Moov",
                  Moov(
                    userData: userData,
                    return1: false,
                  )),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 110),
            child: Row(
              children: [
                _Btn(
                    'images/NigerTélécom.png',
                    'Niger Télécoms',
                    NigerTelecoms(
                      userData: userData,
                      return1: false,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        _top(userData: userData),
                        const SizedBox(
                          height: 20,
                        ),
                        // Factures
                        Text(
                          SwicthLangues(
                              userData: userData, fr: 'Factures', en: 'Bills'),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _Factures(userData: userData),
                        const SizedBox(
                          height: 20,
                        ),
                        // Abonnements
                        Text(
                          SwicthLangues(
                              userData: userData,
                              fr: 'Abonnements',
                              en: 'Subscription'),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _Abonnements(userData: userData),
                        const SizedBox(
                          height: 20,
                        ),
                        // Abonnements
                        Text(
                          SwicthLangues(
                              userData: userData, fr: 'Crédits', en: 'Credits'),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            _Credits(userData: userData),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Loading();
              }
            }));
  }
}
