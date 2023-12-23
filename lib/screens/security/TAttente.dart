import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHomeWeb.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class TransactionsAttente extends StatefulWidget {
  TransactionsAttente({super.key, required this.MyUid, required this.userData});
  final String MyUid;
  final AppUserData userData;
  @override
  State<TransactionsAttente> createState() => _TransactionsAttenteState();
}

class _TransactionsAttenteState extends State<TransactionsAttente> {
  // final AuthenticationService _auth = AuthenticationService();
  late List<Map<String, dynamic>> items;
  bool isLoaded = false;
  String text = "Historique vide";
  // ignore: unused_field
  var time = DateTime.now();
  bool _isLoading = false;
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

  _incrementCounter({required collection}) async {
    List<Map<String, dynamic>> tempsList = [];
    var data = await collection.get();

    data.docs.forEach((element) {
      tempsList.add(element.data());
      if (mounted)
        return setState(() {
          items = tempsList;
          isLoaded = true;
        });
    });
  }

  void _destory({required index}) async {
    await FirebaseFirestore.instance
        .collection('${widget.MyUid}')
        .doc(items[index]["order"])
        .delete();
    var collection = await FirebaseFirestore.instance
        .collection('${widget.MyUid}')
        .orderBy("order", descending: true);
    await _incrementCounter(collection: collection);
    onClick = true;
  }

  void Succes(
      {required items,
      required items1,
      required int index,
      required databaseS,
      required AppUserData userDataS}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return WSucces(
              items1: items1,
              items: items,
              index: index,
              databaseS: databaseS,
              userDataS: userDataS);
        });
  }

  Widget WSucces(
      {required items,
      required items1,
      required int index,
      required databaseS,
      required AppUserData userDataS}) {
    final databaseR = DatabaseService(items['uid']);
    return StreamProvider<AppUserData?>.value(
        value: databaseR.user,
        initialData: null,
        child: StreamBuilder<AppUserData>(
            stream: databaseR.user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                AppUserData? userDataR = snapshot.data;
                if (userDataR == null) return Loading();

                return Container(
                  height: MediaQuery.of(context).size.height / 2.7,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.drag_handle),
                          ),
                          _imputNumber(
                              PlayerNumber: items['Name'],
                              userData: widget.userData),
                          const SizedBox(height: 20),
                          _imputAmount(
                              PlayerAmount: items['Solde'],
                              userData: widget.userData),
                          const SizedBox(height: 30),
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _inputConfirmR(
                                    items1: items1,
                                    index: index,
                                    items: items,
                                    databaseR: databaseR,
                                    databaseS: databaseS,
                                    userDataR: userDataR,
                                    userDataS: userDataS),
                                SizedBox(width: 15),
                                _inputConfirmC(
                                    index: index, items: items, items1: items1),
                                const SizedBox(height: 20),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return Loading();
              }
            }));
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
            fr: 'Numéro de réabonnement :  $PlayerNumber',
            en: 'Resubscription number :  $PlayerNumber'),
        style: TextStyle(fontSize: 24, letterSpacing: 5),
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
        style: TextStyle(fontSize: 24, letterSpacing: 5),
      )),
    );
  }

  Widget _inputConfirmC({required int index, required items, required items1}) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: 50,
        child: ElevatedButton(
          onPressed: onClick
              ? () async {
                  setState(() {
                    onClick = false;
                    _isLoading = true;
                  });
                  var month = data[time.month];
                  _day();
                  _mois();
                  _hours();
                  _minutes();
                  _seconds();
                  var collection = FirebaseFirestore.instance
                      .collection('Confirm ${widget.MyUid}');
                  var collectionM = FirebaseFirestore.instance
                      .collection('Message ${items['uid']}');
                  print('Message ${items['uid']}');
                  await collection
                      .doc('${time.year}$mois$day$hours$minutes$seconds')
                      .set({
                    "Name": items['Name'],
                    "Date":
                        ' $day $month ${time.year}      à      ${time.hour}h : ${time.minute}mn ',
                    "Solde": items['Solde'],
                    "order": '${time.year}$mois$day$hours$minutes$seconds'
                  });
                  if (widget.userData.name == 'Canal+') {
                    await collectionM
                        .doc('${time.year}$mois$day$hours$minutes$seconds')
                        .set({
                      "Name": 'Votre demande de réabonnement a été effectué',
                      "order": '${time.year}$mois$day$hours$minutes$seconds'
                    });
                  } else if (widget.userData.name == 'Agence') {
                    await collectionM
                        .doc('${time.year}$mois$day$hours$minutes$seconds')
                        .set({
                      "Name": 'Votre envoyer a été effectué',
                      "order": '${time.year}$mois$day$hours$minutes$seconds'
                    });
                  } else {
                    await collectionM
                        .doc('${time.year}$mois$day$hours$minutes$seconds')
                        .set({
                      "Name": 'Votre achat de crédit a été effectué',
                      "order": '${time.year}$mois$day$hours$minutes$seconds'
                    });
                  }
                  if (items.length == 1) {
                    _destory(index: index);
                    isLoaded = true;
                    text = "No Data";
                    setState(() {});

                    wPushReplaceTo1(context, BankAppWeb());
                  } else {
                    _destory(index: index);
                    Navigator.of(context).pop();
                  }
                  setState(() {
                    _isLoading = false;
                  });
                }
              : null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                SwicthColor(userData: widget.userData)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: Text(
            SwicthLangues(
                userData: widget.userData, fr: 'Confirmer', en: 'Confirm'),
            style: TextStyle(fontSize: 24),
          ),
        ));
  }

  Widget _inputConfirmR(
      {required int index,
      required items,
      required DatabaseService databaseS,
      required DatabaseService databaseR,
      required AppUserData userDataS,
      required AppUserData userDataR,
      required items1}) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            setState(() {
              onClick = false;
              _isLoading = true;
            });

            // await FirebaseFirestore.instance
            //     .collection("users")
            //     .doc(widget.MyUid)
            //     .update({
            //   'waterCount': userDataS.waterCounter - int.parse(items['Solde']),
            // });

            var month = data[time.month];
            _day();
            _mois();
            _hours();
            _minutes();
            _seconds();
            var collection =
                FirebaseFirestore.instance.collection('Rejete ${widget.MyUid}');
            var collectionM = FirebaseFirestore.instance
                .collection('Message ${items['uid']}');
            var collectionF = FirebaseFirestore.instance
                .collection('Factures ${items['uid']}');
            await collection
                .doc('${time.year}$mois$day$hours$minutes$seconds')
                .set({
              "Name": items['Name'],
              "Date":
                  ' $day $month ${time.year}      à      ${time.hour}h : ${time.minute}mn ',
              "Solde": items['Solde'],
              "order": '${time.year}$mois$day$hours$minutes$seconds'
            });

            if (widget.userData.name == 'Canal+') {
              _day();
              _mois();
              _hours();
              _minutes();
              _seconds();
              await collectionM
                  .doc('${time.year}$mois$day$hours$minutes$seconds')
                  .set({
                "Name": 'Votre demande de réabonnement a été rejeté',
                "order": '${time.year}$mois$day$hours$minutes$seconds'
              });
              await collectionF
                  .doc('${time.year}$mois$day$hours$minutes$seconds')
                  .set({
                "uid": widget.MyUid,
                "Factures": int.parse(items['Solde']),
                "order": '${time.year}$mois$day$hours$minutes$seconds'
              });
            } else if (widget.userData.name == 'Agence') {
              _day();
              _mois();
              _hours();
              _minutes();
              _seconds();
              await collectionM
                  .doc('${time.year}$mois$day$hours$minutes$seconds')
                  .set({
                "Name": 'Votre envoyer a été rejeté',
                "order": '${time.year}$mois$day$hours$minutes$seconds'
              });
              await collectionF
                  .doc('${time.year}$mois$day$hours$minutes$seconds')
                  .set({
                "uid": widget.MyUid,
                "Factures": int.parse(items['Solde']),
                "order": '${time.year}$mois$day$hours$minutes$seconds'
              });
            } else {
              _day();
              _mois();
              _hours();
              _minutes();
              _seconds();
              await collectionM
                  .doc('${time.year}$mois$day$hours$minutes$seconds')
                  .set({
                "Name": 'Votre achat de crédit a été rejeté',
                "order": '${time.year}$mois$day$hours$minutes$seconds'
              });
              await collectionF
                  .doc('${time.year}$mois$day$hours$minutes$seconds')
                  .set({
                "uid": widget.MyUid,
                "Factures": int.parse(items['Solde']),
                "order": '${time.year}$mois$day$hours$minutes$seconds'
              });
            }

            if (items1.length == 1) {
              _destory(index: index);
              isLoaded = true;
              text = "No Data";
              setState(() {});

              wPushReplaceTo1(context, BankAppWeb());
            } else {
              _destory(index: index);
            }

            setState(() {
              onClick = true;
              _isLoading = false;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: Text(
            SwicthLangues(
                userData: widget.userData, fr: 'Rejete', en: 'Rejete'),
            style: TextStyle(fontSize: 24),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var collection = FirebaseFirestore.instance
        .collection('${widget.MyUid}')
        .orderBy("order", descending: true);

    final user = Provider.of<AppUser?>(context);
    if (user == null) throw Exception("user not found");
    final databaseS = DatabaseService(user.uid);
    return StreamProvider<AppUserData?>.value(
        value: databaseS.user,
        initialData: null,
        child: StreamBuilder<AppUserData>(
            stream: databaseS.user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                AppUserData? userDataS = snapshot.data;
                if (userDataS == null) return Loading();
                return _isLoading
                    ? Loading()
                    : Scaffold(
                        appBar: AppBar(
                          leading: IconButton(
                            onPressed: () {
                              wPushReplaceTo2(context, BankAppWeb());
                            },
                            icon: Icon(
                              Iconsax.back_square,
                              color: Colors.black,
                            ),
                          ),
                          title: Text(
                            'Attente',
                            style: TextStyle(
                                fontSize: 32,
                                letterSpacing: 5,
                                color: Colors.black),
                          ),
                          centerTitle: true,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                        extendBodyBehindAppBar: true,
                        body: FutureBuilder(
                            future: _incrementCounter(collection: collection),
                            builder: (context, snapshot) {
                              return Center(
                                  child: isLoaded
                                      ? Center(
                                          child: ListView.builder(
                                          itemCount: items.length,
                                          itemBuilder: (context, index) {
                                            return _HistoryItems(
                                                index: index,
                                                userDataS: userDataS,
                                                databaseS: databaseS);
                                          },
                                        ))
                                      : Text(
                                          style: TextStyle(
                                              color: DefaultSelectionStyle
                                                  .defaultColor),
                                          text));
                            }),
                        floatingActionButton: FloatingActionButton(
                          backgroundColor:
                              SwicthColor(userData: widget.userData),
                          onPressed: () async {
                            print('${widget.MyUid}');
                            var collection = FirebaseFirestore.instance
                                .collection('${widget.MyUid}')
                                .orderBy("order", descending: true);
                            _incrementCounter(collection: collection);
                          },
                          tooltip: 'increment',
                          child: const Icon(
                            Iconsax.refresh_circle,
                            size: 30,
                          ),
                        ),
                      );
              } else {
                return Loading();
              }
            }));
  }

  Widget _HistoryItems(
      {required int index,
      required databaseS,
      required AppUserData userDataS}) {
    return GestureDetector(
      onTap: () {
        Succes(
            items1: items,
            items: items[index],
            index: index,
            userDataS: userDataS,
            databaseS: databaseS);
      },
      child: Padding(
          padding: const EdgeInsets.all(6),
          child: Card(
            shape: RoundedRectangleBorder(
                // side: const BorderSide(width: 0),
                borderRadius: BorderRadius.circular(1200)),
            elevation: 6,
            child: ListTile(
              shape: RoundedRectangleBorder(
                  // side: const BorderSide(width: 0),
                  borderRadius: BorderRadius.circular(1200)),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Iconsax.receipt),
              ),
              title: Text(items[index]["Name"],
                  style: GoogleFonts.poppins(
                      letterSpacing: 2.5,
                      fontSize: 24,
                      fontWeight: FontWeight.w500)),
              subtitle: Text(items[index]["Date"],
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              trailing: Text("${items[index]["Solde"].toString()} ECO",
                  style: GoogleFonts.poppins(
                      letterSpacing: 2.5,
                      fontSize: 20,
                      fontWeight: FontWeight.w400)),
            ),
          )),
    );
  }
}
