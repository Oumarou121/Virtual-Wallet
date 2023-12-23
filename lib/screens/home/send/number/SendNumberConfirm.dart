import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:virtual_wallet_2/screens/home/send/number/SendNumberAmount.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class SendNumberConfirm extends StatefulWidget {
  SendNumberConfirm(
      {super.key,
      required this.IdR,
      required this.IdS,
      required this.Facture,
      required this.isNumber,
      required this.Name,
      required this.urlImage});
  final String IdR;
  final String IdS;
  final String Name;
  final String urlImage;
  final int Facture;
  final bool isNumber;

  @override
  State<SendNumberConfirm> createState() => _SendNumberConfirmState();
}

class _SendNumberConfirmState extends State<SendNumberConfirm> {
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
      required databaseS,
      required databaseR,
      required AppUserData userDataS,
      required AppUserData userDataR,
      required MyUid,
      required collectionS,
      required collectionR,
      required collectionM}) async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      wShowToast(SwicthLangues(
          userData: userDataS,
          fr: "La Confirmation Biometrique n\'est pas disponible",
          en: 'Biometrics is unavailable by with phone'));
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
    _authenticateWithBiometrics(
        MyAmount: MyAmount,
        Factures: Factures,
        databaseS: databaseS,
        databaseR: databaseR,
        userDataS: userDataS,
        userDataR: userDataR,
        MyUid: MyUid,
        collectionS: collectionS,
        collectionR: collectionR,
        collectionM: collectionM);
  }

  Future<void> _authenticateWithBiometrics(
      {required int MyAmount,
      required int Factures,
      required databaseS,
      required databaseR,
      required AppUserData userDataS,
      required AppUserData userDataR,
      required MyUid,
      required collectionS,
      required collectionR,
      required collectionM}) async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: SwicthLangues(
            userData: userDataS,
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
              databaseS: databaseS,
              databaseR: databaseR,
              userDataS: userDataS,
              userDataR: userDataR,
              MyUid: MyUid,
              collectionS: collectionS,
              collectionR: collectionR,
              collectionM: collectionM);
        } else {
          setState(() {
            onClick = true;
            error = SwicthLangues(
                userData: userDataS,
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
      required databaseS,
      required databaseR,
      required AppUserData userDataS,
      required AppUserData userDataR,
      required MyUid,
      required collectionS,
      required collectionR,
      required collectionM}) async {
    var month = data[time.month];
    _day();
    _mois();
    _hours();
    _minutes();
    _seconds();

    await databaseS.saveUser(
        userDataS.name,
        userDataS.waterCounter - widget.Facture,
        userDataS.password,
        userDataS.passwordSign,
        userDataS.playerUid,
        userDataS.phone,
        userDataS.token,
        userDataS.ImageUrl,
        userDataS.DBiometrique,
        userDataS.CBiometrique,
        userDataS.autoBrightness,
        userDataS.isDark,
        userDataS.primaryColor,
        userDataS.langues);
    await databaseR.saveUser(
        userDataR.name,
        userDataR.waterCounter + widget.Facture,
        userDataR.password,
        userDataR.passwordSign,
        userDataR.playerUid,
        userDataR.phone,
        userDataR.token,
        userDataR.ImageUrl,
        userDataR.DBiometrique,
        userDataR.CBiometrique,
        userDataR.autoBrightness,
        userDataR.isDark,
        userDataR.primaryColor,
        userDataR.langues);

    await collectionS.doc('${time.year}$mois$day$hours$minutes$seconds').set({
      "Image": 'images/profile.png',
      "Phone": userDataR.phone,
      "Name": widget.isNumber ? widget.Name : userDataR.name,
      "Date":
          ' $day $month ${time.year}      à      ${time.hour}h : ${time.minute}mn ',
      "Solde": widget.Facture,
      "order": '${time.year}$mois$day$hours$minutes$seconds'
    });
    await collectionR.doc('${time.year}$mois$day$hours$minutes$seconds').set({
      "Image": 'images/profile.png',
      "Phone": userDataS.phone,
      "Name": userDataS.name,
      "Date":
          ' $day $month ${time.year}      à      ${time.hour}h : ${time.minute}mn ',
      "Solde": widget.Facture,
      "order": '${time.year}$mois$day$hours$minutes$seconds'
    });
    await collectionM.doc('${time.year}$mois$day$hours$minutes$seconds').set({
      "Name":
          'Vous venez de recevoir ${widget.Facture} de la part de ${userDataS.name}',
      "order": '${time.year}$mois$day$hours$minutes$seconds'
    });

    Succes(userData: userDataS);
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

  Widget _inputConfirm(
      {required AppUserData userDataR,
      required AppUserData userDataS,
      required databaseR,
      required databaseS,
      required MyUid}) {
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
            if (widget.IdR == widget.IdS) {
              error = SwicthLangues(
                  userData: userDataS,
                  fr: 'On ne peut pas s\'auto-envoyer',
                  en: 'We cannot self send');
            } else {
              final databaseR = DatabaseService(widget.IdR);
              var collectionS =
                  FirebaseFirestore.instance.collection('Send ${widget.IdS}');
              var collectionR = FirebaseFirestore.instance
                  .collection('Receive ${widget.IdR}');
              var collectionM = FirebaseFirestore.instance
                  .collection('Message ${widget.IdR}');
              if (widget.Facture <= userDataS.waterCounter) {
                if (userDataS.CBiometrique == true) {
                  setState(() {
                    _isLoading = false;
                  });
                  _checkBiometrics(
                      collectionM: collectionM,
                      MyAmount: userDataS.waterCounter,
                      Factures: widget.Facture,
                      databaseS: databaseS,
                      databaseR: databaseR,
                      userDataS: userDataS,
                      userDataR: userDataR,
                      MyUid: MyUid,
                      collectionS: collectionS,
                      collectionR: collectionR);
                } else {
                  SuccesAction(
                      collectionM: collectionM,
                      MyAmount: userDataS.waterCounter,
                      Factures: widget.Facture,
                      databaseS: databaseS,
                      databaseR: databaseR,
                      userDataS: userDataS,
                      userDataR: userDataR,
                      MyUid: MyUid,
                      collectionS: collectionS,
                      collectionR: collectionR);
                }
              } else {
                setState(() {
                  _isLoading = false;
                  error = SwicthLangues(
                      userData: userDataS,
                      fr: 'Votre Solde est insuffisant',
                      en: 'Your balance is insufficient');
                });
              }
            }
          }
        },
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(SwicthColor(userData: userDataS)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        child: Text(
            SwicthLangues(userData: userDataS, fr: 'Confirmer', en: 'Confirm')),
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

  Widget _top({required userDataS}) {
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
                  SwicthLangues(userData: userDataS, fr: 'Envoyer', en: 'Send'),
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
                  SendNumberAmount(
                    IdS: widget.IdS,
                    IdR: widget.IdR,
                    isNumber: widget.isNumber,
                    Name: widget.Name,
                    urlImage: widget.urlImage,
                    userData: userDataS,
                    return1: true,
                  )),
            ))
      ]),
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
            fr: 'Nom du bénéficien : $PlayerName',
            en: 'Name of beneficiary : $PlayerName'),
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
            fr: 'Numéro du bénéficien : $PlayerNumber',
            en: 'Number of beneficiary : $PlayerNumber'),
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

  Widget _SendConfirm(
      {required PlayerName,
      required PlayerNumber,
      required PlayerAmount,
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
            _imputAmount(PlayerAmount: PlayerAmount, userData: userData),
          ],
        ),
      ),
    );
  }

  // String mtoken = '';
  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // void requestPermission() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   NotificationSettings settings = await messaging.requestPermission(
  //       alert: true,
  //       announcement: false,
  //       badge: true,
  //       carPlay: false,
  //       criticalAlert: false,
  //       provisional: false,
  //       sound: true);

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User granted permission');
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     print('User granted provisional permission');
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }
  // }

  // void getToken() async {
  //   await FirebaseMessaging.instance
  //       .getToken(
  //           vapidKey:
  //               "BNBObvfA7A4ZBk1CcYaC1CzMJipgHdFndwnH-RAWLdrFfLIXwmUe9e8k3H2xWG9Cp75jC3rm_rJ-Ah_bNsvqe7k")
  //       .then((token) {
  //     setState(() {
  //       mtoken = token!;
  //       print("My token is $mtoken");
  //     });
  //   });
  // }

  // initInfo() {
  //   var androidInitialize =
  //       const AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var iOSInitialize = const DarwinInitializationSettings();
  //   var initializationsSettings =
  //       InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

  //   flutterLocalNotificationsPlugin.initialize(
  //     initializationsSettings,
  //     onDidReceiveNotificationResponse: (payload) async {
  //       try {
  //         // ignore: unnecessary_null_comparison
  //         if (payload != null && payload.toString().isNotEmpty) {
  //         } else {}
  //       } catch (e) {}
  //       return;
  //     },
  //   );

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     print("...................onMessage..............");
  //     print(
  //         "onMessage:${message.notification?.title}/${message.notification?.body}");
  //     BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
  //         message.notification!.body.toString(),
  //         htmlFormatContentTitle: true);
  //     AndroidNotificationDetails androidPlatformChannelSpecifics =
  //         AndroidNotificationDetails(
  //       'dbfood',
  //       'dbfood',
  //       importance: Importance.max,
  //       styleInformation: bigTextStyleInformation,
  //       priority: Priority.max,
  //       playSound: true,
  //       sound: RawResourceAndroidNotificationSound('notification'),
  //     );
  //     NotificationDetails platformChannelSpecifics = NotificationDetails(
  //         android: androidPlatformChannelSpecifics,
  //         iOS: const DarwinNotificationDetails());
  //     await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
  //         message.notification?.body, platformChannelSpecifics,
  //         payload: message.data['body']);
  //   });
  // }

  // void sendPushMessage(String token, String body, String title) async {
  //   try {
  //     await http.post(
  //       Uri.parse(
  //           'https://fcm.googleapis.com/v1/projects/my-virtual-wallet-5f4d7/messages:send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization':
  //             'key=BNBObvfA7A4ZBk1CcYaC1CzMJipgHdFndwnH-RAWLdrFfLIXwmUe9e8k3H2xWG9Cp75jC3rm_rJ-Ah_bNsvqe7k'
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           'priority': 'high',
  //           'data': <String, dynamic>{
  //             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //             'status': 'done',
  //             'body': body,
  //             'title': title,
  //           },
  //           "notification": <String, dynamic>{
  //             "title": title,
  //             "body": body,
  //             "android_channel_id": "dbfood"
  //           },
  //           "to": token,
  //         },
  //       ),
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('error push notification');
  //     }
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   requestPermission();
  //   getToken();
  //   initInfo();
  // }

  @override
  Widget build(BuildContext context) {
    // NotificationService.initialize();
    final user = Provider.of<AppUser?>(context);
    if (user == null) throw Exception("user not found");
    final databaseR = DatabaseService(widget.IdR);
    final databaseS = DatabaseService(user.uid);
    return StreamProvider<AppUserData?>.value(
        value: databaseR.user,
        initialData: null,
        child: StreamBuilder<AppUserData>(
            stream: databaseR.user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                AppUserData? userDataR = snapshot.data;
                if (userDataR == null) return Loading();
                return StreamProvider<AppUserData?>.value(
                    value: databaseS.user,
                    initialData: null,
                    child: StreamBuilder<AppUserData>(
                        stream: databaseS.user,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            AppUserData? userDataS = snapshot.data;
                            if (userDataS == null) return Loading();
                            return Scaffold(
                              body: _isLoading
                                  ? Loading()
                                  : SafeArea(
                                      child: GestureDetector(
                                      onTap: () =>
                                          FocusScope.of(context).unfocus(),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 0),
                                        child: Column(
                                          children: [
                                            _top(userDataS: userDataS),
                                            const SizedBox(height: 200),
                                            Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                      style: TextStyle(
                                                          color:
                                                              DefaultSelectionStyle
                                                                  .defaultColor),
                                                      SwicthLangues(
                                                          userData: userDataS,
                                                          fr: "Voulez-vous vraiment transfère",
                                                          en: "Do you really want to transfer")),
                                                  SizedBox(height: 15),
                                                  _SendConfirm(
                                                    userData: userDataS,
                                                    PlayerName: widget.isNumber
                                                        ? widget.Name
                                                        : userDataR.name,
                                                    PlayerNumber:
                                                        userDataR.phone,
                                                    PlayerAmount:
                                                        widget.Facture,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            _inputConfirm(
                                                MyUid: user.uid,
                                                userDataR: userDataR,
                                                userDataS: userDataS,
                                                databaseR: databaseR,
                                                databaseS: databaseS),
                                            const SizedBox(height: 10),
                                            Text(
                                              error,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14),
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
              } else {
                return Loading();
              }
            }));
  }
}
