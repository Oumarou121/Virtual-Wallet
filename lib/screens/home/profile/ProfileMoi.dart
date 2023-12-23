// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/authentication/login_screen.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:virtual_wallet_2/sevices/authentication.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class ProfileMoi extends StatefulWidget {
  ProfileMoi({super.key, required this.userData});
  var userData;
  @override
  State<ProfileMoi> createState() => _ProfileMoiState();
}

class _ProfileMoiState extends State<ProfileMoi> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final AuthenticationService _auth = AuthenticationService();
  TextEditingController _name = TextEditingController();
  String phoneNumber = '';
  String error = '';
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

  bool _isModification = false;
  Widget _inputNameModif({required userData}) {
    return Container(
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        controller: _name,
        decoration: InputDecoration(
            hintText: SwicthLangues(userData: userData, fr: 'Nom', en: 'Name'),
            helperText: SwicthLangues(
                userData: userData,
                fr: 'Entert votre nom complet',
                en: 'Enter Full Name'),
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

  Widget _inputUidModif({required String PlayerUid}) {
    return Container(
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        // controller: _name,
        initialValue: PlayerUid,
        decoration: InputDecoration(
            // hintText: 'Name',
            // helperText: 'Entert Full Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.supervised_user_circle_rounded)),
      ),
    );
  }

  Widget _inputPaysModif() {
    return Container(
      child: TextFormField(
        initialValue: 'Niger',
        textCapitalization: TextCapitalization.words,
        // controller: _name,
        decoration: InputDecoration(
            // hintText: 'Name',
            // helperText: 'Entert Full Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.supervised_user_circle_rounded)),
      ),
    );
  }

  Widget _inputConfirm({required AppUserData userData, required database}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 64,
      child: ElevatedButton(
        onPressed: () async {
          if (_isModification == false) {
            setState(() {
              _isModification = true;
            });
          } else {
            if (_formkey.currentState!.validate()) {
              if (phoneNumber.isNotEmpty) {
                var collection = FirebaseFirestore.instance.collection("users");

                var num = await collection
                    .where("phone", isEqualTo: phoneNumber)
                    .get();
                if (num.size == 0) {
                  await database.saveUser(
                      _name.text,
                      userData.waterCounter,
                      userData.password,
                      userData.passwordSign,
                      userData.playerUid,
                      phoneNumber,
                      userData.token,
                      userData.ImageUrl,
                      userData.DBiometrique,
                      userData.CBiometrique,
                      userData.autoBrightness,
                      userData.isDark,
                      userData.primaryColor,
                      userData.langues);
                  setState(() {
                    _isModification = false;
                  });
                } else {
                  setState(() {
                    error = SwicthLangues(
                        userData: userData,
                        fr: 'Ce Numero est déjà utilisé',
                        en: 'This Phone Number is already using');
                  });
                }
              }
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
        child: _isModification
            ? Text(SwicthLangues(
                userData: userData, fr: 'Confirmer', en: 'Confirm'))
            : Text("Modifier"),
      ),
    );
  }

  Widget _imputName({required PlayerName, required userData}) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
      child: Center(
          child: Text(
        '${SwicthLangues(userData: userData, fr: 'Mon Nom', en: 'My Name')} : $PlayerName',
        // 'Mon  Nom :  $PlayerName',
        style: TextStyle(fontSize: 16),
      )),
    );
  }

  Widget _imputNumber({required PlayerNumber, required userData}) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
      child: Center(
          child: Text(
        '${SwicthLangues(userData: userData, fr: 'Mon Numéro', en: 'My Number')} : $PlayerNumber',
        // 'Mon Numéro :  $PlayerNumber',
        style: TextStyle(fontSize: 16),
      )),
    );
  }

  Widget _imputUid({required PlayerUid, required userData}) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
      child: Center(
          child: Text(
        '${SwicthLangues(userData: userData, fr: 'Mon Uid', en: 'My Uid')} : $PlayerUid',
        // 'Mon Uid :  $PlayerUid',
        style: TextStyle(fontSize: 16),
      )),
    );
  }

  Widget _imputPays({required PlayerPays, required userData}) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
      child: Center(
          child: Text(
        '${SwicthLangues(userData: userData, fr: 'Mon Pays', en: 'My Countrie')} : $PlayerPays',

        // 'Mon Pays :  $PlayerPays',
        style: TextStyle(fontSize: 16),
      )),
    );
  }

  Widget _SendConfirm(
      {required PlayerName,
      required PlayerNumber,
      required PlayerAmount,
      required PlayerPays,
      required userData}) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Center(
        child: Column(
          children: [
            _imputName(PlayerName: PlayerName, userData: userData),
            const SizedBox(height: 10),
            _imputNumber(PlayerNumber: PlayerNumber, userData: userData),
            const SizedBox(height: 10),
            _imputUid(PlayerUid: PlayerAmount, userData: userData),
            const SizedBox(height: 10),
            _imputPays(PlayerPays: PlayerPays, userData: userData),
          ],
        ),
      ),
    );
  }

  Widget _modification({required String PlayerUid, required userData}) {
    return Center(
        child: Column(children: [
      _inputNameModif(userData: userData),
      const SizedBox(height: 20),
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
          labelText: 'Phone Number',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      _imputUid(PlayerUid: PlayerUid, userData: userData),
      const SizedBox(height: 20),
      _imputPays(PlayerPays: 'Niger', userData: userData)
    ]));
  }

  @override
  Widget build(BuildContext context) {
    // NotificationService.initialize();
    final user = Provider.of<AppUser?>(context);
    if (user == null) return LoginScreen(userData: widget.userData);
    final database = DatabaseService(user.uid);
    return StreamProvider<AppUserData?>.value(
        value: database.user,
        initialData: null,
        child: StreamBuilder<AppUserData>(
            stream: database.user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                AppUserData? userData = snapshot.data;
                if (userData == null)
                  return LoginScreen(userData: widget.userData);
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: () {
                        wPushReplaceTo2(context, BankApp(index: 2));
                      },
                      icon: Icon(
                        Iconsax.back_square,
                        color: Colors.black,
                      ),
                    ),
                    actions: [
                      Center(
                        child: Text(
                          SwicthLangues(
                              userData: widget.userData,
                              fr: 'Déconnection',
                              en: 'Logout'),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            await _auth.signOut();
                            wPushReplaceTo1(
                                context,
                                LoginScreen(
                                  userData: userData,
                                ));
                          },
                          icon: Icon(
                            Iconsax.login,
                            color: Colors.black,
                          )),
                    ],
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  extendBodyBehindAppBar: true,
                  body: SafeArea(
                      child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 4.5,
                          ),
                          _isModification
                              ? Form(
                                  key: _formkey,
                                  child: _modification(
                                      PlayerUid: user.uid, userData: userData))
                              : Center(
                                  child: Column(
                                    children: [
                                      _SendConfirm(
                                          PlayerName: userData.name,
                                          PlayerNumber: userData.phone,
                                          PlayerAmount: user.uid,
                                          PlayerPays: 'Niger',
                                          userData: userData)
                                    ],
                                  ),
                                ),
                          SizedBox(height: 20),
                          _inputConfirm(userData: userData, database: database),
                          Center(
                            child: Text(error,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16)),
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
