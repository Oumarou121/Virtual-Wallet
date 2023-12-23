import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/send/SendType.dart';
import 'package:virtual_wallet_2/screens/home/send/agence/SendAgenceAmount.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class SendAgence extends StatefulWidget {
  SendAgence(
      {super.key,
      required this.IdS,
      required this.userData,
      required this.return1});
  String IdS;
  var userData;
  final bool return1;

  @override
  State<SendAgence> createState() => _SendAgenceState();
}

class _SendAgenceState extends State<SendAgence> {
  TextEditingController _name = TextEditingController();

  String error = '';
  String PhoneNumber = '';
  String IdR = '';
  AppUserData? userData;
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

  Widget _inputName() {
    return Container(
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        controller: _name,
        decoration: InputDecoration(
            prefixIconColor: SwicthColor(userData: userData),
            hintText: SwicthLangues(
                userData: userData,
                fr: 'Nom du bénéficien',
                en: 'Name of beneficiary'),
            helperText: SwicthLangues(
                userData: userData,
                fr: 'Entert son nom complet',
                en: 'Entert Full Name'),
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.supervised_user_circle_rounded)),
        validator: (val) => uValidator(
          value: val,
          isRequred: true,
          minLength: 3,
        ),
      ),
    );
  }

  Widget _inputConfirm(
      {required String IdS,
      required String NameR,
      required String NumberR,
      required databaseS,
      required userDataS}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 64,
      child: ElevatedButton(
          onPressed: () async {
            var collection = FirebaseFirestore.instance.collection("users");

            var num =
                await collection.where("phone", isEqualTo: PhoneNumber).get();
            print(num.size);
            if (PhoneNumber.isEmpty) {
              setState(() {
                error = SwicthLangues(
                    userData: userData,
                    fr: 'Veillez saisir le numéro du receveur',
                    en: 'Please enter the receiver number');
              });
            } else {
              if (num.size == 0) {
                wPushReplaceTo2(
                    context,
                    SendAgenceAmount(
                      IdS: IdS,
                      databaseS: databaseS,
                      userDataS: userDataS,
                      NameR: NameR,
                      NumberR: NumberR,
                      userData: widget.userData,
                      return1: false,
                    ));
              } else {
                setState(() {
                  error = SwicthLangues(
                      userData: userData,
                      fr: 'Ce numéro possède un compte',
                      en: 'This number has an account');
                });
              }
            }
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
          child: Text(SwicthLangues(
              userData: userData, fr: 'Confirmer', en: 'Confirm'))),
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
                onPressed: () {
                  if (widget.return1 == false) {
                    wPushReplaceTo2(context, SendType(userData: userData));
                  } else {
                    wPushReplaceTo2(context, SendType(userData: userData));
                  }
                }))
      ]),
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
                return Scaffold(
                  body: SafeArea(
                      child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: Column(
                        children: [
                          _top(),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 3.5),
                          _inputName(),
                          const SizedBox(height: 10),
                          IntlPhoneField(
                            countries: countries,
                            onChanged: (value) {
                              setState(() {
                                PhoneNumber = value.completeNumber;
                              });
                              print(value.completeNumber);
                            },
                            initialCountryCode: 'NE',
                            decoration: InputDecoration(
                              labelText: SwicthLangues(
                                  userData: widget.userData,
                                  fr: 'Numéro du bénéficien',
                                  en: 'Number of beneficiary'),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _inputConfirm(
                              IdS: user.uid,
                              NameR: _name.text,
                              NumberR: PhoneNumber,
                              databaseS: database,
                              userDataS: userData),
                          const SizedBox(height: 10),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )),
                );
              } else {
                return Loading();
              }
            }));
  }
}
