import 'package:flutter/material.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/screens/authentication/login_screen.dart';
import 'package:virtual_wallet_2/sevices/authentication.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key, required this.userData});
  var userData;
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthenticationService _auth = AuthenticationService();
  TextEditingController _email = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String error = '';
  bool _isLoading = false;

  Widget _inputEmail() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _email,
        decoration: InputDecoration(
            prefixIconColor: SwicthColor(userData: widget.userData),
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

  @override
  Widget build(BuildContext context) {
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
                          LoginScreen(
                            userData: widget.userData,
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2.5,
                          fit: BoxFit.contain,
                          image: const AssetImage(
                              "images/img_forgot_password.png"),
                        ),
                        SizedBox(height: 0),
                        Text(
                          SwicthLangues(
                              userData: widget.userData,
                              fr: "Mot de passe oublier",
                              en: "Forgot Password"),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 10),
                        Text(
                          SwicthLangues(
                              userData: widget.userData,
                              fr: "Ne t\’inquiète pas! Cela arrive. Veuillez saisir l\’adresse e-mail associée à votre compte.",
                              en: "Don't worry! It happens. Please enter the email that associated with yout Account."),
                          style: Theme.of(context)
                              .textTheme
                              // ignore: deprecated_member_use
                              .button
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 50),
                        _inputEmail(),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                dynamic result =
                                    await _auth.resetPassword(email: _email);
                                await Future.delayed(Duration(seconds: 2));
                                setState(() {
                                  _isLoading = false;
                                });
                                print(result);
                                if (mounted) {
                                  if (result = true) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    wPushReplaceTo1(
                                        context,
                                        LoginScreen(
                                          userData: widget.userData,
                                        ));
                                    wShowToast(SwicthLangues(
                                        userData: widget.userData,
                                        fr: 'Email Envoie! Veillez verifier vos email',
                                        en: 'Email Sended! Please check your email to reset passworld.'));
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                      error = SwicthLangues(
                                          userData: widget.userData,
                                          fr: 'Cet email n\'existe pas',
                                          en: 'This email does not exist');
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
                                fr: 'Envoyer',
                                en: 'Send')),
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                  ),
                )),
              ));
  }
}
