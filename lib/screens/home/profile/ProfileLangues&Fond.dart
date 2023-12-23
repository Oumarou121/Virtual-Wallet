import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
class ProfileLanguesFond extends StatefulWidget {
  ProfileLanguesFond(
      {super.key,
      required this.userData,
      required this.isAuto,
      required this.isSombre});
  bool isAuto;
  bool isSombre;
  AppUserData userData;
  @override
  State<ProfileLanguesFond> createState() => _ProfileLanguesFondState();
}

List<String> langues = ['Français', 'Anglais'];
List<String> Mode = ['Automatique', 'Sombre', 'Clair'];
List<String> CouleurG = ['Color1', 'Color2', 'Color3'];

class _ProfileLanguesFondState extends State<ProfileLanguesFond> {
  final AuthenticationService _auth = AuthenticationService();
  String currentLangues = langues[0];
  String currentMode = Mode[0];
  String currentCouleurG = CouleurG[0];

  Widget _Langues({required userData}) {
    return Column(
      children: [
        RadioListTile(
          activeColor: SwicthColor(userData: userData),
          title: Text(
              SwicthLangues(userData: userData, fr: 'Français', en: 'French')),
          value: langues[0],
          groupValue: currentLangues,
          onChanged: (value) {
            setState(() {
              currentLangues = value.toString();
            });
          },
        ),
        RadioListTile(
          activeColor: SwicthColor(userData: userData),
          title: Text(
              SwicthLangues(userData: userData, fr: 'Anglais', en: 'English')),
          value: langues[1],
          groupValue: currentLangues,
          onChanged: (value) {
            setState(() {
              currentLangues = value.toString();
            });
          },
        )
      ],
    );
  }

  Widget _Mode({required userData}) {
    return Column(
      children: [
        RadioListTile(
          activeColor: SwicthColor(userData: userData),
          title: Text(SwicthLangues(
              userData: userData, fr: 'Automatique', en: 'Automatic')),
          value: Mode[0],
          groupValue: currentMode,
          onChanged: (value) {
            setState(() {
              currentMode = value.toString();
              widget.isAuto = true;
            });
          },
        ),
        RadioListTile(
          activeColor: SwicthColor(userData: userData),
          title:
              Text(SwicthLangues(userData: userData, fr: 'Sombre', en: 'Dark')),
          value: Mode[1],
          groupValue: currentMode,
          onChanged: (value) {
            setState(() {
              currentMode = value.toString();
              widget.isAuto = false;
              widget.isSombre = true;
            });
          },
        ),
        RadioListTile(
          activeColor: SwicthColor(userData: userData),
          title:
              Text(SwicthLangues(userData: userData, fr: 'Clair', en: 'Light')),
          value: Mode[2],
          groupValue: currentMode,
          onChanged: (value) {
            setState(() {
              currentMode = value.toString();
              widget.isAuto = false;
              widget.isSombre = false;
            });
          },
        ),
      ],
    );
  }

  Widget _CouleurG({required userData}) {
    return Column(
      children: [
        RadioListTile(
          activeColor: SwicthColor(userData: userData),
          title: Text('Couleur1'),
          value: CouleurG[0],
          groupValue: currentCouleurG,
          onChanged: (value) {
            setState(() {
              currentCouleurG = value.toString();
            });
          },
        ),
        RadioListTile(
          activeColor: SwicthColor(userData: userData),
          title: Text('Couleur2'),
          value: CouleurG[1],
          groupValue: currentCouleurG,
          onChanged: (value) {
            setState(() {
              currentCouleurG = value.toString();
            });
          },
        ),
        RadioListTile(
          activeColor: SwicthColor(userData: userData),
          title: Text('Couleur3'),
          value: CouleurG[2],
          groupValue: currentCouleurG,
          onChanged: (value) {
            setState(() {
              currentCouleurG = value.toString();
            });
          },
        )
      ],
    );
  }

  _initSecurity({required AppUserData userData}) async {
    currentCouleurG = userData.primaryColor;
    currentLangues = userData.langues;
    if (userData.autoBrightness == true) {
      currentMode = 'Automatique';
    } else {
      if (userData.isDark == true) {
        currentMode = 'Sombre';
      } else {
        currentMode = 'Clair';
      }
    }
  }

  @override
  void initState() {
    _initSecurity(userData: widget.userData);
    super.initState();
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
                if (userData == null) return Loading();
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
                                userData: userData,
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
                    body: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        padding:
                            EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                        child: Column(
                          children: [
                            // Langues
                            const Text(
                              'Langues',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _Langues(userData: userData),
                            const SizedBox(
                              height: 20,
                            ),
                            // Fonds
                            const Text(
                              'Mode',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _Mode(userData: userData),
                            const SizedBox(
                              height: 20,
                            ),
                            // Abonnements
                            Text(
                              SwicthLangues(
                                  userData: userData,
                                  fr: 'Couleur Général',
                                  en: 'Primary Color'),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                _CouleurG(userData: userData),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 64,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await database.saveUser(
                                      userData.name,
                                      userData.waterCounter,
                                      userData.password,
                                      userData.passwordSign,
                                      userData.playerUid,
                                      userData.phone,
                                      userData.token,
                                      userData.ImageUrl,
                                      userData.DBiometrique,
                                      userData.CBiometrique,
                                      widget.isAuto,
                                      widget.isSombre,
                                      currentCouleurG,
                                      currentLangues);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      SwicthColor(userData: userData)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                child: Text(SwicthLangues(
                                    userData: userData,
                                    fr: 'Confirmer',
                                    en: 'Confirm')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              } else {
                return Loading();
              }
            }));
  }
}
