// ignore_for_file: must_be_immutable, unused_element

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/security/CodePin%201.dart';
import 'package:virtual_wallet_2/screens/security/CreatePinCode.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class Forgot_PinCode extends StatefulWidget {
  Forgot_PinCode({super.key, required this.userData});
  var userData;
  @override
  State<Forgot_PinCode> createState() => _Forgot_PinCodeState();
}

class _Forgot_PinCodeState extends State<Forgot_PinCode> {
  TextEditingController _password = TextEditingController();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  String error = '';

  Widget _inputPassword({required userData}) {
    return TextFormField(
        controller: _password,
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
            ));
  }

  Widget _inputSubmit({required userData}) {
    return Container(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            backgroundColor: Colors.indigo,
          ),
          child: Text(
              SwicthLangues(userData: userData, fr: 'Envoyer', en: 'Send')),
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              setState(() => _isLoading = true);
              await Future.delayed(Duration(seconds: 2));

              if (_password.text == userData.passwordSign) {
                setState(() => _isLoading = false);

                wPushReplaceTo1(
                    context,
                    CreatePinCode(
                      userData: widget.userData,
                    ));
                print('yes');
              } else {
                setState(() => _isLoading = false);
                print('no');

                setState(() {
                  error = SwicthLangues(
                      userData: userData,
                      fr: 'Verifier votre mot de passe',
                      en: 'Check your password');
                });
              }
            }
          },
        ));
  }

  // Widget _inputEmail() {
  //   return Container(
  //     child: TextFormField(
  //       keyboardType: TextInputType.emailAddress,
  //       controller: _password,
  //       decoration: InputDecoration(
  //           prefixIconColor: SwicthColor(userData: widget.userData),
  //           labelText: 'Email',
  //           border: OutlineInputBorder(),
  //           prefixIcon: Icon(Icons.email)),
  //       validator: (val) => uValidator(
  //         value: val,
  //         isRequred: true,
  //         isEmail: true,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // NotificationService.initialize();
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
                    child: _isLoading
                        ? Loading()
                        : Scaffold(
                            appBar: AppBar(
                              leading: IconButton(
                                onPressed: () {
                                  wPushReplaceTo1(
                                      context,
                                      CodePin(
                                        Password: userData.password,
                                      ));
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.black,
                                ),
                              ),
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                            extendBodyBehindAppBar: true,
                            body: SingleChildScrollView(
                                child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Form(
                                key: _formkey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image(
                                      width: MediaQuery.of(context).size.width,
                                      height: 350,
                                      fit: BoxFit.contain,
                                      image: const AssetImage(
                                          "images/img_forgot_password.png"),
                                    ),
                                    SizedBox(height: 0),
                                    Text(
                                      SwicthLangues(
                                          userData: userData,
                                          fr: "Code Pin oublier",
                                          en: "Forgot Pin Code"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      SwicthLangues(
                                          userData: userData,
                                          fr: "Ne t\’inquiète pas! Cela arrive. Veuillez saisir l\’adresse e-mail associée à votre compte.",
                                          en: "Don't worry! It happens. Please enter the email that associated with yout Account."),
                                      style: Theme.of(context)
                                          .textTheme
                                          // ignore: deprecated_member_use
                                          .button
                                          ?.copyWith(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 50),
                                    _inputPassword(userData: userData),
                                    const SizedBox(height: 30),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 64,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            setState(() => _isLoading = true);
                                            await Future.delayed(
                                                Duration(seconds: 2));

                                            if (_password.text ==
                                                userData.passwordSign) {
                                              setState(
                                                  () => _isLoading = false);

                                              wPushReplaceTo1(
                                                  context,
                                                  CreatePinCode(
                                                    userData: widget.userData,
                                                  ));
                                              print('yes');
                                            } else {
                                              setState(
                                                  () => _isLoading = false);
                                              print('no');

                                              setState(() {
                                                error = SwicthLangues(
                                                    userData: userData,
                                                    fr: 'Verifier votre mot de passe',
                                                    en: 'Check your password');
                                              });
                                            }
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  SwicthColor(
                                                      userData:
                                                          widget.userData)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                            style: TextStyle(
                                                color: DefaultSelectionStyle
                                                    .defaultColor),
                                            SwicthLangues(
                                                userData: userData,
                                                fr: "Envoyer",
                                                en: "Send")),
                                      ),
                                    ),
                                    const SizedBox(),
                                  ],
                                ),
                              ),
                            )),
                          ));
              } else {
                return Loading();
              }
            }));
  }
}
