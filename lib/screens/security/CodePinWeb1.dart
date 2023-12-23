import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/authentication/login_screen.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHomeWeb.dart';
import 'package:virtual_wallet_2/screens/security/CodePinWeb2.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class CodePinWeb1 extends StatefulWidget {
  CodePinWeb1({super.key});
  @override
  State<CodePinWeb1> createState() => _CodePinWeb1State();
}

class _CodePinWeb1State extends State<CodePinWeb1> {
  double size = 45;

  var custom = DefaultSelectionStyle.defaultColor;
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
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: [
                      IconButton(
                          onPressed: () {
                            wPushReplaceTo1(
                                context,
                                LoginScreen(
                                  userData: userData,
                                ));
                          },
                          icon: Icon(
                            Iconsax.login,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  body: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: MediaQuery.of(context).size.height / 4,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Entre votre Code Pin',
                            style: TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Veillez entre votre Code Pin pour continuer',
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 30),
                          PinInputTextField(
                            autoFocus: true,
                            pinLength: 12,
                            decoration: CirclePinDecoration(
                                strokeWidth: 2,
                                strokeColorBuilder: FixedColorBuilder(custom)),
                            onChanged: (value) async {
                              if (value.length == 12) {
                                if (value == userData.password) {
                                  wPushReplaceTo1(context, BankAppWeb());
                                }
                                if (value != userData.password) {
                                  setState(() {
                                    custom = Colors.red;
                                  });
                                  await Future.delayed(Duration(seconds: 1));
                                  setState(() {
                                    custom = DefaultSelectionStyle.defaultColor;
                                  });
                                  wPushReplaceTo1(context, CodePinWeb2());
                                }
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Loading();
              }
            }));
  }
}
