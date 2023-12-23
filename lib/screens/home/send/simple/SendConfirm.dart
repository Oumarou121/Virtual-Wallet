import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_wallet_2/screens/home/send/simple/SendAmount.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class SendConfirm extends StatefulWidget {
  SendConfirm({super.key, required this.Amount, required this.UidR});
  String UidR;
  var Amount;

  @override
  State<SendConfirm> createState() => _SendConfirmState();
}

class _SendConfirmState extends State<SendConfirm> {
  String error = '';
  var time = DateTime.now();
  bool _isLoading = false;
// ignore: unused_field
  bool? _canCheckBiometrics;
  // ignore: unused_field
  String _authorized = 'Not Authorized';
  // ignore: unused_field
  bool _isAuthenticating = false;
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _checkBiometrics(
      {required int MyAmount,
      required int Factures,
      required database,
      required databaseR,
      required AppUserData userData,
      required AppUserData userDataR,
      required MyUid,
      required collectionS,
      required collectionR}) async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      wShowToast(SwicthLangues(
          userData: userData,
          fr: "La Confirmation Biometrique n\'est pas disponible",
          en: 'Biometrics is unavailable by with phone'));
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      // _isLoading = false;
      // error = 'Pas de biometrique sur ce téléphone';
      // onClick = true;

      _canCheckBiometrics = canCheckBiometrics;
    });
    _authenticateWithBiometrics(
        MyAmount: MyAmount,
        Factures: Factures,
        database: database,
        databaseR: databaseR,
        userData: userData,
        userDataR: userDataR,
        MyUid: MyUid,
        collectionS: collectionS,
        collectionR: collectionR);
  }

  Future<void> _authenticateWithBiometrics(
      {required int MyAmount,
      required int Factures,
      required database,
      required databaseR,
      required AppUserData userData,
      required AppUserData userDataR,
      required MyUid,
      required collectionS,
      required collectionR}) async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: SwicthLangues(
            userData: userData,
            fr: 'Scannez votre empreinte digitale (ou votre visage pour vous authentifier)',
            en: 'Scan your fingerprint (or face or whatever) to authenticate'),
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
        if (authenticated = true) {
          setState(() {
            _isLoading = true;
          });
          SuccesAction(
              MyAmount: MyAmount,
              Factures: Factures,
              database: database,
              databaseR: databaseR,
              userData: userData,
              userDataR: userDataR,
              MyUid: MyUid,
              collectionS: collectionS,
              collectionR: collectionR);
        } else {
          setState(() {
            onClick = true;
            error = SwicthLangues(
                userData: userData,
                fr: 'Erreur d\'authentification',
                en: 'Authenticating error');
          });
        }
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
        onClick = true;
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
        // wShowToast('Too many failed attempts. Please try again later');
        wShowToast("${e.message}");
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> SuccesAction(
      {required int MyAmount,
      required int Factures,
      required database,
      required databaseR,
      required AppUserData userData,
      required AppUserData userDataR,
      required MyUid,
      required collectionS,
      required collectionR}) async {
    var month = data[time.month];
    _day();
    _mois();
    _hours();
    _minutes();
    _seconds();

    await database.saveUser(
        userData.name,
        userData.waterCounter - int.parse(widget.Amount.toString()),
        userData.password,
        userData.passwordSign,
        userData.playerUid,
        userData.phone,
        userData.token,
        userData.ImageUrl,
        userData.DBiometrique,
        userData.CBiometrique,
        userData.autoBrightness,
        userData.isDark,
        userData.primaryColor,
        userData.langues);
    await databaseR.saveUser(
        userDataR.name,
        userDataR.waterCounter + int.parse(widget.Amount.toString()),
        userDataR.password,
        userDataR.passwordSign,
        userDataR.playerUid,
        userDataR.phone,
        userDataR.token,
        userDataR.ImageUrl,
        userDataR.DBiometrique,
        userDataR.CBiometrique,
        userData.autoBrightness,
        userData.isDark,
        userData.primaryColor,
        userData.langues);
    await collectionS.doc('${time.year}$mois$day$hours$minutes$seconds').set({
      "Image": "images/Gaz.png",
      "Name": userDataR.name,
      "Date":
          ' $day $month ${time.year}      à      ${time.hour}h : ${time.minute}mn ',
      "Solde": int.parse(widget.Amount.toString()),
      "order": '${time.year}$mois$day$hours$minutes$seconds'
    });
    await collectionR.doc('${time.year}$mois$day$hours$minutes$seconds').set({
      "Image": 'images/profile.png',
      "Name": userData.name,
      "Date":
          ' $day $month ${time.year}      à      ${time.hour}h : ${time.minute}mn ',
      "Solde": int.parse(widget.Amount.toString()),
      "order": '${time.year}$mois$day$hours$minutes$seconds'
    });

    Succes(userData: userData);
  }

  var data = [
    '',
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Aout',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre'
  ];

  bool onClick = true;

  var day;

  void _day() {
    if (time.day < 10) {
      setState(() {
        day = '0${time.day}';
      });
    } else {
      day = time.day;
    }
  }

  var mois;

  void _mois() {
    if (time.month < 10) {
      setState(() {
        mois = '0${time.month}';
      });
    } else {
      mois = time.month;
    }
  }

  var hours;

  void _hours() {
    if (time.hour < 10) {
      setState(() {
        hours = '0${time.hour}';
      });
    } else {
      hours = time.hour;
    }
  }

  var minutes;

  void _minutes() {
    if (time.minute < 10) {
      setState(() {
        minutes = '0${time.minute}';
      });
    } else {
      minutes = time.minute;
    }
  }

  var seconds;

  void _seconds() {
    if (time.second < 10) {
      setState(() {
        seconds = '0${time.second}';
      });
    } else {
      seconds = time.second;
    }
  }

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
                  '      ',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                ),
                SizedBox(width: 10),
                Text(
                  SwicthLangues(
                      userData: userData, fr: 'Achats', en: 'Purchases'),
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
                onPressed: () => wPushReplaceTo2(
                    context,
                    SendAmount(
                        UidR: widget.UidR, userData: userData, return1: true))))
      ]),
    );
  }

  Widget _SendID(
      {required AppUserData userData,
      required AppUserData userDataR,
      required database,
      required databaseR,
      required MyUid}) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Center(
        child: Column(
          children: [
            _imputName(PlayerName: userDataR.name, userData: userData),
            const SizedBox(height: 20),
            _imputNumber(PlayerNumber: userDataR.phone, userData: userData),
            const SizedBox(height: 20),
            _imputAmount(PlayerAmount: widget.Amount, userData: userData),
            const SizedBox(height: 30),
            _inputConfirm(
                userData: userData,
                database: database,
                userDataR: userDataR,
                MyUid: MyUid)
          ],
        ),
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
        SwicthLangues(
            userData: userData,
            fr: 'Nom du receveur :  $PlayerName',
            en: 'Name of receive :  $PlayerName'),
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
        SwicthLangues(
            userData: userData,
            fr: 'Numéro du receveur :  $PlayerNumber',
            en: 'Number of receive :  $PlayerNumber'),
        style: TextStyle(fontSize: 16),
      )),
    );
  }

  Widget _imputAmount({required PlayerAmount, required userData}) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
      child: Center(
          child: Text(
        SwicthLangues(
            userData: userData,
            fr: 'Montant :  $PlayerAmount',
            en: 'Amount :  $PlayerAmount'),
        style: TextStyle(fontSize: 16),
      )),
    );
  }

  Widget _inputConfirm({
    required database,
    required AppUserData userData,
    required AppUserData userDataR,
    required MyUid,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 64,
      child: ElevatedButton(
        onPressed: () async {
          if (onClick = true) {
            setState(() {
              _isLoading = true;
              onClick = false;
            });
            if (widget.UidR == MyUid) {
              setState(() {
                onClick = true;
                error = SwicthLangues(
                    userData: userData,
                    fr: 'On ne peut pas s\'auto-envoyer',
                    en: 'We cannot self send');
              });
            } else {
              final databaseR = DatabaseService(widget.UidR);
              var collectionS =
                  FirebaseFirestore.instance.collection('Transactions $MyUid');
              var collectionR = FirebaseFirestore.instance
                  .collection('History ${widget.UidR}');
              if (widget.Amount <= userData.waterCounter) {
                if (userData.CBiometrique == true) {
                  setState(() {
                    _isLoading = false;
                  });
                  _checkBiometrics(
                      MyAmount: userData.waterCounter,
                      Factures: widget.Amount,
                      database: database,
                      databaseR: databaseR,
                      userData: userData,
                      userDataR: userDataR,
                      MyUid: MyUid,
                      collectionS: collectionS,
                      collectionR: collectionR);
                } else {
                  SuccesAction(
                      MyAmount: userData.waterCounter,
                      Factures: widget.Amount,
                      database: database,
                      databaseR: databaseR,
                      userData: userData,
                      userDataR: userDataR,
                      MyUid: MyUid,
                      collectionS: collectionS,
                      collectionR: collectionR);
                }
              } else {
                setState(() {
                  _isLoading = false;
                  error = SwicthLangues(
                      userData: userData,
                      fr: 'Votre Solde est insuffisant',
                      en: 'Your balance is insufficient');
                });
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
        child: Text(
            SwicthLangues(userData: userData, fr: 'Confirmer', en: 'Confirm')),
      ),
    );
  }

  void Succes({required userData}) {
    setState(() {
      _isLoading = false;
    });
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) {
          return _Succes(userData: userData);
        });
  }

  Widget _Succes({required userData}) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(10),
            child: Icon(Icons.drag_handle),
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                width: 200,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade300),
                child: TextButton(
                  child: Text(
                      SwicthLangues(
                          userData: userData, fr: 'Succès', en: 'Success'),
                      style: TextStyle(fontSize: 32)),
                  onPressed: () => wPushReplaceTo1(
                      context,
                      BankApp(
                        index: 0,
                      )),
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // NotificationService.initialize();

    final user = Provider.of<AppUser?>(context);
    if (user == null) throw Exception("user not found");
    final database = DatabaseService(user.uid);
    final databaseR = DatabaseService(widget.UidR);
    return StreamProvider<AppUserData?>.value(
        value: database.user,
        initialData: null,
        child: StreamBuilder<AppUserData>(
            stream: database.user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                AppUserData? userData = snapshot.data;
                if (userData == null) return Loading();
                return StreamProvider<AppUserData?>.value(
                    value: databaseR.user,
                    initialData: null,
                    child: StreamBuilder<AppUserData>(
                        stream: databaseR.user,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            AppUserData? userDataR = snapshot.data;
                            if (userDataR == null) return Loading();
                            return Scaffold(
                              // backgroundColor: Colors.grey.shade100,
                              body: _isLoading
                                  ? Loading()
                                  : SafeArea(
                                      child: GestureDetector(
                                      onTap: () =>
                                          FocusScope.of(context).unfocus(),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Column(
                                          children: [
                                            _top(userData: userData),
                                            const SizedBox(
                                              height: 230,
                                            ),
                                            Text(
                                                style: TextStyle(
                                                    color: DefaultSelectionStyle
                                                        .defaultColor),
                                                SwicthLangues(
                                                    userData: userData,
                                                    fr: "Voulez-vous vraiment transfère",
                                                    en: "Do you really want to transfer")),
                                            SizedBox(height: 15),
                                            _SendID(
                                                userData: userData,
                                                userDataR: userDataR,
                                                database: database,
                                                databaseR: databaseR,
                                                MyUid: user.uid),
                                            Text(
                                              error,
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                            );
                          } else {
                            return Loading();
                          }
                        }));
              } else {
                return Loading();
              }
            }));
  }
}