// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/screens/authentication/login_screen.dart';
import 'package:virtual_wallet_2/screens/security/CreatePinCode.dart';
import 'package:virtual_wallet_2/sevices/authentication.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key, required this.userData});
  var userData;
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthenticationService _auth = AuthenticationService();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordConf = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _obscureText1 = true;

  bool _isLoading = false;
  String error = '';
  String phoneNumber = '';
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

  Widget _inputName({required userData}) {
    return Container(
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        controller: _name,
        decoration: InputDecoration(
            prefixIconColor: SwicthColor(userData: userData),
            hintText: SwicthLangues(userData: userData, fr: 'Nom', en: 'Name'),
            helperText: SwicthLangues(
                userData: userData,
                fr: 'Entert votre nom complet',
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

  Widget _inputEmail({required userData}) {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _email,
        decoration: InputDecoration(
            prefixIconColor: SwicthColor(userData: userData),
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email)),
        validator: (val) => uValidator(
          value: val,
          isRequred: true,
          isEmail: true,
        ),
      ),
    );
  }

  Widget _inputPassword({required userData}) {
    return Stack(
      children: <Widget>[
        // ignore: avoid_unnecessary_containers
        Container(
          child: TextFormField(
              controller: _password,
              obscureText: _obscureText,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                  prefixIconColor: SwicthColor(userData: userData),
                  labelText: SwicthLangues(
                      userData: userData, fr: 'Mot de passe', en: 'Password'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock)),
              validator: (val) => uValidator(
                    value: val,
                    isRequred: true,
                    minLength: 6,
                  )),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                // color: Colors.grey[600],
                color: SwicthColor(userData: userData),
              ),
              onPressed: () {
                setState(() => _obscureText = !_obscureText);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _inputPasswordConfirm({required userData}) {
    return Stack(
      children: <Widget>[
        // ignore: avoid_unnecessary_containers
        Container(
          child: TextFormField(
              controller: _passwordConf,
              obscureText: _obscureText1,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                  prefixIconColor: SwicthColor(userData: userData),
                  labelText: SwicthLangues(
                      userData: userData,
                      fr: 'Confirmer votre mot de passe',
                      en: 'Password Confirm'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock)),
              validator: (val) => uValidator(
                  value: val,
                  isRequred: true,
                  minLength: 6,
                  match: _password.text)),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: IconButton(
              icon: Icon(
                _obscureText1 ? Icons.visibility_off : Icons.visibility,
                color: SwicthColor(userData: userData),
              ),
              onPressed: () {
                setState(() => _obscureText1 = !_obscureText1);
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _isLoading
            ? Loading()
            : Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    SwicthLangues(
                        userData: widget.userData,
                        fr: "Inscription",
                        en: 'Register'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                        onPressed: () {
                          wPushReplaceTo5(
                              context,
                              LoginScreen(
                                userData: widget.userData,
                              ));
                        },
                        icon: Icon(
                          Iconsax.login,
                          color: Colors.black,
                        ))
                  ],
                ),
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3,
                          fit: BoxFit.contain,
                          image: const AssetImage("images/img_register.png"),
                        ),
                        SizedBox(height: 4),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _inputName(userData: widget.userData),
                            SizedBox(height: 24),
                            _inputEmail(userData: widget.userData),
                            SizedBox(height: 24),
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
                                    userData: widget.userData,
                                    fr: 'Numéro de téléphone',
                                    en: 'Phone Number'),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 24),
                            _inputPassword(userData: widget.userData),
                            SizedBox(height: 24),
                            _inputPasswordConfirm(userData: widget.userData)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 34),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 64,
                              child: ElevatedButton(
                                onPressed: () async {
                                  var collection = FirebaseFirestore.instance
                                      .collection("users");

                                  var num = await collection
                                      .where("phone", isEqualTo: phoneNumber)
                                      .get();
                                  print(num);
                                  print(phoneNumber);
                                  if (_formkey.currentState!.validate()) {
                                    if (phoneNumber.isNotEmpty) {
                                      if (num.size == 0) {
                                        setState(() => _isLoading = true);
                                        dynamic result = await _auth
                                            .registerWithEmailAndPassword(
                                                name: _name.text,
                                                email: _email,
                                                password: _password.text,
                                                phoneNumber: phoneNumber);

                                        if (result != null) {
                                          setState(() {
                                            _isLoading = false;
                                            print(result);
                                          });
                                          if (result ==
                                              '[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
                                            setState(() {
                                              _isLoading = false;
                                              error = SwicthLangues(
                                                  userData: widget.userData,
                                                  fr: 'Veillez vérifier votre connexion internet',
                                                  en: 'Please check your internet connection');
                                            });
                                          } else {
                                            if (result ==
                                                '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
                                              setState(() {
                                                _isLoading = false;
                                                error = SwicthLangues(
                                                    userData: widget.userData,
                                                    fr: 'Cet email est déjà utiliser',
                                                    en: 'This Email is already using');
                                              });
                                            } else {
                                              if (result == 'true') {
                                                wPushReplaceTo1(
                                                    context,
                                                    CreatePinCode(
                                                      userData: widget.userData,
                                                    ));
                                              }
                                            }
                                          }
                                        }

                                        // await Future.delayed(
                                        //     Duration(seconds: 2));
                                        // if (mounted) {
                                        //   if (result == false) {
                                        //     setState(() {
                                        //       _isLoading = false;
                                        //       error = SwicthLangues(
                                        //           userData: widget.userData,
                                        //           fr: 'Ce email est déjà utiliser',
                                        //           en: 'This Email is already using');
                                        //       print(result);
                                        //     });
                                        //   } else {
                                        //     wPushReplaceTo1(
                                        //         context,
                                        //         CreatePinCode(
                                        //           userData: widget.userData,
                                        //         ));
                                        //     print(result);
                                        //   }
                                        // }
                                      } else {
                                        setState(() {
                                          error = SwicthLangues(
                                              userData: widget.userData,
                                              fr: 'Ce Numéro est déjà utiliser',
                                              en: 'This Phone Number is already using');
                                          _isLoading = false;
                                        });
                                      }
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      SwicthColor(userData: widget.userData)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                child: Text(SwicthLangues(
                                    userData: widget.userData,
                                    fr: 'Inscription',
                                    en: 'Register')),
                              ),
                            ),
                            Center(
                              child: Text(error,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )),
              ));
  }
}
