import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:random_color/random_color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/screens/home/contacts/ContactsHome.dart';
import 'package:virtual_wallet_2/screens/home/contacts/modificationContacts.dart';
import 'package:virtual_wallet_2/screens/home/history/HistoryReceivePlayer.dart';
import 'package:virtual_wallet_2/screens/home/history/HistorySendPlayer.dart';
import 'package:virtual_wallet_2/screens/home/send/number/SendNumberAmount.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class DetailsContacts extends StatefulWidget {
  DetailsContacts(
      {super.key,
      required this.Name,
      required this.urlImage,
      required this.PhoneNumber,
      required this.MyUid,
      required this.YourUid,
      required this.userData});
  var userData;
  String Name;
  String urlImage;
  String PhoneNumber;
  String MyUid;
  String YourUid;
  @override
  State<DetailsContacts> createState() => _DetailsContactsState();
}

class _DetailsContactsState extends State<DetailsContacts> {
  bool _isLoading = false;

  static RandomColor _randomColor = RandomColor();
  Color _color =
      _randomColor.randomColor(colorBrightness: ColorBrightness.light);
  _lancerAppel() async {
    final Uri launchUri = Uri(scheme: 'tel', path: widget.PhoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Impossible d\'appeller $launchUri';
    }
  }

  _lancerSms() async {
    final Uri launchUri = Uri(scheme: 'sms', path: widget.PhoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Impossible de texter $launchUri';
    }
  }

  var lettreInitial;
  bool hideUi = true;
  _checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      if (mounted)
        return setState(() {
          hideUi = false;
        });
    } else {
      if (mounted)
        return setState(() {
          hideUi = true;
        });
    }
  }

  Widget affichageImage() {
    _checkConnection();
    if (hideUi = true) {
      if (widget.urlImage != '') {
        lettreInitial = "";
        return CircleAvatar(
          radius: 90,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage('${widget.urlImage}'),
        );
      } else {
        lettreInitial = widget.Name[0];
        return CircleAvatar(
          radius: 90,
          backgroundColor: _color,
          child: Text(
            lettreInitial!,
            style: TextStyle(fontSize: 75),
          ),
        );
      }
    } else {
      return CircleAvatar(
        radius: 90,
        backgroundColor: _color,
        child: Text(''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  wPushReplaceTo2(
                      context,
                      ContactsHome(
                        MyUid: widget.MyUid,
                        userData: widget.userData,
                      ));
                },
                icon: Icon(
                  Iconsax.back_square,
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      wPushReplaceTo2(
                          context,
                          ModificationContacts(
                            userData: widget.userData,
                            Name: widget.Name,
                            Name1: widget.Name,
                            PhoneNumber: widget.PhoneNumber,
                            PhoneNumber1: widget.PhoneNumber,
                            urlImage: widget.urlImage,
                            MyUid: widget.MyUid,
                          ));
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await FirebaseFirestore.instance
                          .collection('Contacts ${widget.MyUid}')
                          .doc('${widget.Name}${widget.PhoneNumber}')
                          .delete();
                      print('${widget.Name}${widget.PhoneNumber}');
                      setState(() {
                        wPushReplaceTo2(
                            context,
                            ContactsHome(
                              MyUid: widget.MyUid,
                              userData: widget.userData,
                            ));
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.black,
                    )),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 05, vertical: 70),
                child: Column(
                  children: [
                    affichageImage(),
                    SizedBox(height: 10),
                    Text(
                      '${widget.Name}',
                      style: GoogleFonts.poppins(
                          fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: _lancerAppel,
                          child: Column(
                            children: [
                              Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(Icons.phone_outlined,
                                      color: Colors.black)),
                              SizedBox(height: 5),
                              Text(
                                SwicthLangues(
                                    userData: widget.userData,
                                    fr: 'Appel',
                                    en: 'Call'),
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _lancerSms,
                          child: Column(
                            children: [
                              Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(Icons.sms_outlined,
                                      color: Colors.black)),
                              SizedBox(height: 5),
                              Text(
                                'SMS',
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            wPushReplaceTo2(
                                context,
                                SendNumberAmount(
                                  userData: widget.userData,
                                  IdS: widget.MyUid,
                                  IdR: widget.YourUid,
                                  isNumber: true,
                                  Name: widget.Name,
                                  urlImage: widget.urlImage,
                                  return1: false,
                                ));
                          },
                          child: Column(
                            children: [
                              Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(Icons.send_outlined,
                                      color: Colors.black)),
                              SizedBox(height: 5),
                              Text(
                                SwicthLangues(
                                    userData: widget.userData,
                                    fr: 'Envoyer',
                                    en: 'Send'),
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            selectImage(userData: widget.userData);
                          },
                          child: Column(
                            children: [
                              Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(Icons.receipt_long_outlined,
                                      color: Colors.black)),
                              SizedBox(height: 5),
                              Text(
                                SwicthLangues(
                                    userData: widget.userData,
                                    fr: 'Historique',
                                    en: 'History'),
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    Divider(
                      height: 20,
                      color: Colors.grey[800],
                    ),
                    Row(
                      children: [
                        SizedBox(height: 50),
                        SizedBox(width: 10),
                        Icon(Icons.phone),
                        SizedBox(width: 80),
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                '${widget.PhoneNumber}',
                                style: GoogleFonts.poppins(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      height: 20,
                      color: Colors.grey[800],
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void selectImage({required userData}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _SelectImage(userData: userData);
        });
  }

  Widget _SelectImage({required userData}) {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                _MyListTileSend(
                  titleName: SwicthLangues(
                      userData: userData,
                      fr: 'Historique d\'envoie',
                      en: 'Send History'),
                  IconName: Iconsax.send,
                ),
                SizedBox(height: 10),
                _MyListTileReceive(
                  titleName: SwicthLangues(
                      userData: userData,
                      fr: 'Historique de réception',
                      en: 'Receive History'),
                  IconName: Iconsax.receipt,
                ),
                // Divider(height: 40, indent: 50, endIndent: 50),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _MyListTileSend({required String titleName, required IconName}) {
    return GestureDetector(
      onTap: () {
        wPushReplaceTo2(
            context,
            HistorySendPlayer(
              PhoneNumber: widget.PhoneNumber,
              MyUid: widget.MyUid,
              userData: widget.userData,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // icon
              Row(
                children: [
                  Container(
                    height: 80,
                    padding: EdgeInsets.all(12),
                    child: Icon(IconName),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),

              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  Widget _MyListTileReceive({required String titleName, required IconName}) {
    return GestureDetector(
      onTap: () {
        wPushReplaceTo2(
            context,
            HistoryReceivePlayer(
              PhoneNumber: widget.PhoneNumber,
              MyUid: widget.MyUid,
              userData: widget.userData,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // icon
              Row(
                children: [
                  Container(
                    height: 80,
                    padding: EdgeInsets.all(12),
                    child: Icon(IconName),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),

              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
