// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:virtual_wallet_2/screens/home/cr%C3%A9dits/ZamaniConfirm.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class Zamani extends StatefulWidget {
  Zamani({super.key, required this.userData, required this.return1});
  var userData;
  final bool return1;
  @override
  State<Zamani> createState() => _ZamaniState();
}

class _ZamaniState extends State<Zamani> {
  // TextEditingController _PlayerID = TextEditingController();
  TextEditingController _PlayerAmount = TextEditingController();
  String qrCode = '';
  String error = '';
  String phoneNumber = '';
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  List<Country> countries = [
    Country(
      name: "Niger",
      nameTranslations: {
        "sk": "Niger",
        "se": "Niger",
        "pl": "Niger",
        "no": "Niger",
        "ja": "ニジェール",
        "it": "Niger",
        "zh": "尼日尔",
        "nl": "Niger",
        "de": "Niger",
        "fr": "Niger",
        "es": "Níger",
        "en": "Niger",
        "pt_BR": "Níger",
        "sr-Cyrl": "Нигер",
        "sr-Latn": "Niger",
        "zh_TW": "尼日爾",
        "tr": "Nijer",
        "ro": "Niger",
        "ar": "النيجر",
        "fa": "نیجر",
        "yue": "尼日爾"
      },
      flag: "🇳🇪",
      code: "NE",
      dialCode: "227",
      minLength: 8,
      maxLength: 8,
    ),
  ];

  Widget _SendID({required userData}) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Center(
        child: Column(
          children: [
            IntlPhoneField(
              countries: countries,
              onChanged: (value) {
                setState(() {
                  phoneNumber = value.completeNumber;
                });
                print(value.completeNumber);
              },
              initialCountryCode: 'NE',
              decoration: InputDecoration(
                labelText: SwicthLangues(
                    userData: userData,
                    fr: 'Numéro du bénéficien',
                    en: 'Number of beneficiary'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _imputAmount(userData: userData),
            const SizedBox(height: 20),
            _inputConfirm(userData: userData)
          ],
        ),
      ),
    );
  }

  // // ignore: unused_element
  // Widget _imputNumero() {
  //   return Container(
  //     child: TextFormField(
  //       keyboardType: TextInputType.number,
  //       controller: _PlayerID,
  //       decoration: InputDecoration(
  //           hintText: 'Numéro',
  //           helperText: 'Entert Full',
  //           border: OutlineInputBorder(),
  //           prefixIcon: Icon(Icons.numbers)),
  //     ),
  //   );
  // }

  Widget _imputAmount({required userData}) {
    return Container(
      child: TextFormField(
        validator: (val) => uValidator(
            value: val, isRequred: true, minLength: 3, isAmount: true),
        keyboardType: TextInputType.number,
        controller: _PlayerAmount,
        decoration: InputDecoration(
            hintText:
                SwicthLangues(userData: userData, fr: 'Montant', en: 'Amount'),
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.money)),
      ),
    );
  }

  Widget _inputConfirm({required userData}) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              if (phoneNumber.isNotEmpty) {
                wPushReplaceTo2(
                    context,
                    ZamaniConfirm(
                      Amount: _PlayerAmount.text,
                      Numero: phoneNumber,
                    ));
              } else {
                setState(() {
                  error = SwicthLangues(
                      userData: userData,
                      fr: 'Met le Numéro',
                      en: 'Set Number');
                });
              }
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                SwicthColor(userData: widget.userData)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: Text(SwicthLangues(
              userData: userData, fr: 'Confirmer', en: 'Confirm')),
        ));
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
                  'Zamani',
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
          child: Form(
            key: _formkey,
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
        ),
      )),
    );
  }
}
