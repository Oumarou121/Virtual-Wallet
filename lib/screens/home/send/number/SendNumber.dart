import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/send/SendType.dart';
import 'package:virtual_wallet_2/screens/home/send/number/SendNumberAmount.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class SendNumber extends StatefulWidget {
  SendNumber({super.key, required this.IdS, required this.return1});
  final String IdS;
  final bool return1;
  @override
  State<SendNumber> createState() => _SendNumberState();
}

class _SendNumberState extends State<SendNumber> {
  String error = '';
  String PhoneNumber = '';
  String IdR = '';
  AppUserData? userData;
  bool _isLoading = false;
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
  @override
  void initState() {
    setState(() {
      _isLoading = false;
    });
    super.initState();
  }

  Widget _inputConfirm() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 64,
      child: ElevatedButton(
        onPressed: () async {
          if (PhoneNumber.isNotEmpty) {
            setState(() {
              _isLoading = true;
            });
            var collection = FirebaseFirestore.instance.collection("users");

            var num =
                await collection.where("phone", isEqualTo: PhoneNumber).get();
            if (num.size == 1) {
              await collection
                  .where("phone", isEqualTo: PhoneNumber)
                  .get()
                  .then((snapshot) => snapshot.docs.forEach((document) {
                        setState(() {
                          IdR = document.reference.id;
                        });
                      }));
              await wPushReplaceTo2(
                  context,
                  SendNumberAmount(
                    userData: userData,
                    IdS: widget.IdS,
                    IdR: IdR,
                    isNumber: false,
                    urlImage: '',
                    Name: '',
                    return1: false,
                  ));
            } else {
              setState(() {
                error = SwicthLangues(
                    userData: userData,
                    fr: 'Aucun utilisateur trouver',
                    en: 'No User Found');
              });
            }
          } else {
            setState(() {
              error = SwicthLangues(
                  userData: userData,
                  fr: 'Veillez saisir le numéro du receveur',
                  en: 'Please enter the receiver number');
            });
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
    return Scaffold(
      body: _isLoading
          ? Loading()
          : SafeArea(
              child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  children: [
                    _top(),
                    SizedBox(height: MediaQuery.of(context).size.height / 3),
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
                            userData: userData,
                            fr: 'Numéro du bénéficien',
                            en: 'Number of beneficiary'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _inputConfirm(),
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
  }
}
