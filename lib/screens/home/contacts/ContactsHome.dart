// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:random_color/random_color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
import 'package:virtual_wallet_2/screens/home/contacts/PartageContact.dart';
import 'package:virtual_wallet_2/screens/home/contacts/ajoutContacts.dart';
import 'package:virtual_wallet_2/screens/home/contacts/contactQrCode.dart';
import 'package:virtual_wallet_2/screens/home/contacts/detailsContacts.dart';
import 'package:virtual_wallet_2/screens/home/send/number/SendNumberAmount.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class ContactsHome extends StatefulWidget {
  ContactsHome({super.key, required this.MyUid, required this.userData});
  final String MyUid;
  final userData;
  @override
  State<ContactsHome> createState() => _ContactsHomeState();
}

class _ContactsHomeState extends State<ContactsHome> {
  late List<Map<String, dynamic>> items;
  bool isLoaded = false;
  String text = "Loading...";
  bool _isLoading = false;
  static RandomColor _randomColor = RandomColor();
  Color _color =
      _randomColor.randomColor(colorBrightness: ColorBrightness.light);

  _lancerAppel({required String PhoneNumber}) async {
    final Uri launchUri = Uri(scheme: 'tel', path: PhoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Impossible d\'appeller $launchUri';
    }
  }

  _lancerSms({required String PhoneNumber}) async {
    final Uri launchUri = Uri(scheme: 'sms', path: PhoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Impossible de texter $launchUri';
    }
  }

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

  _incrementCounter({required collection}) async {
    await _checkConnection();
    if (hideUi = true) {
      List<Map<String, dynamic>> tempsList = [];
      var data = await collection.get();

      data.docs.forEach((element) {
        tempsList.add(element.data());
        if (mounted)
          return setState(() {
            _isLoading = false;
            items = tempsList;
            isLoaded = true;
            text = 'No Data';
          });
      });
    } else {}
  }

  void _destory({required String Name, required String PhoneNumber}) async {
    setState(() {
      _isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('Contacts ${widget.MyUid}')
        .doc('$Name$PhoneNumber')
        .delete();
    var collection =
        await FirebaseFirestore.instance.collection('Contacts ${widget.MyUid}');
    await _incrementCounter(collection: collection);
    print('Contacts ${widget.MyUid}');
    if (items.length == 1) {
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var collection =
        FirebaseFirestore.instance.collection('Contacts ${widget.MyUid}');
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Contacts",
                style: TextStyle(color: Colors.black, fontSize: 32),
              ),
              leading: IconButton(
                onPressed: () {
                  wPushReplaceTo2(context, BankApp(index: 0));
                },
                icon: Icon(
                  Iconsax.back_square,
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      wPushReplaceTo2(context, PartageContact());
                    },
                    icon: Icon(
                      Icons.contacts_outlined,
                      color: Colors.black,
                    )),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: FutureBuilder(
              future: _incrementCounter(collection: collection),
              builder: (context, snapshot) {
                return Center(
                    child: isLoaded
                        ? Center(
                            child: Card(
                            elevation: 6,
                            child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return _buildListItem(
                                    document: items[index], index: index);
                              },
                            ),
                          ))
                        : Text('Pas de Contacts'));
              },
            ),
            extendBodyBehindAppBar: true,
            floatingActionButton: FloatingActionButton(
              backgroundColor: SwicthColor(userData: widget.userData),
              onPressed: () {
                selectImage();
              },
              tooltip: 'increment',
              child: const Icon(
                Iconsax.add,
                size: 30,
              ),
            ),
          );
  }

  Widget _buildListItem({required var document, required int index}) {
    if (document != null) {
      var lettreInitial;
      Widget affichageImage() {
        if (hideUi = true) {
          if (document['ImageUrl'] != '') {
            lettreInitial = "";
            return CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage('${document['ImageUrl']}'),
            );
          } else {
            lettreInitial = document['Name'][0];
            return CircleAvatar(
              backgroundColor: _color,
              child: Text(
                lettreInitial,
                style: TextStyle(fontSize: 32),
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

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Slidable(
          startActionPane: ActionPane(motion: StretchMotion(), children: [
            SlidableAction(
              onPressed: (context) {
                // call number
                _lancerAppel(PhoneNumber: document['PhoneNumber']);
              },
              backgroundColor: Colors.green,
              icon: Icons.phone,
            ),
            SlidableAction(
              onPressed: (context) {
                // send sms to number
                _lancerSms(PhoneNumber: document['PhoneNumber']);
              },
              backgroundColor: Colors.blue,
              icon: Icons.chat,
            ),
          ]),
          endActionPane: ActionPane(motion: StretchMotion(), children: [
            SlidableAction(
              flex: 2,
              onPressed: (context) {
                // send money to number
                wPushReplaceTo2(
                    context,
                    SendNumberAmount(
                      userData: widget.userData,
                      IdS: widget.MyUid,
                      IdR: document['Uid'],
                      isNumber: true,
                      Name: document['Name'],
                      urlImage: document['ImageUrl'],
                      return1: false,
                    ));
              },
              backgroundColor: Colors.blue,
              icon: Icons.send,
            ),
            SlidableAction(
              flex: 1,
              onPressed: (context) {
                // delete number
                if (items.length == 1) {
                  _destory(
                      Name: document['Name'],
                      PhoneNumber: document['PhoneNumber']);
                  wPushReplaceTo1(context, BankApp(index: 0));
                } else {
                  _destory(
                      Name: document['Name'],
                      PhoneNumber: document['PhoneNumber']);
                }
              },
              backgroundColor: Colors.red,
              icon: Icons.delete_outline,
            ),
          ]),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Card(
              elevation: 2,
              child: ListTile(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 0.2),
                      borderRadius: BorderRadius.circular(0)),
                  onTap: () {
                    wPushReplaceTo2(
                        context,
                        DetailsContacts(
                          Name: document['Name'],
                          urlImage: document['ImageUrl'],
                          PhoneNumber: document['PhoneNumber'],
                          YourUid: document['Uid'],
                          MyUid: widget.MyUid,
                          userData: widget.userData,
                        ));
                  },
                  leading: affichageImage(),
                  title: Text('${document['Name']}',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600))),
            ),
          ),
        ),
      );
    } else {
      return Loading();
    }
  }

  Widget _SelectImage() {
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
                _MyListTileGalery(
                  titleName: SwicthLangues(
                      userData: widget.userData,
                      fr: 'Ajouter par Qr Code',
                      en: 'add by Qr Code'),
                  IconName: Icons.qr_code,
                ),
                SizedBox(height: 10),
                _MyListTileCamera(
                  titleName: SwicthLangues(
                      userData: widget.userData,
                      fr: 'Ajouter manuellement',
                      en: 'Add manually'),
                  IconName: Iconsax.edit,
                ),
                // Divider(height: 40, indent: 50, endIndent: 50),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _MyListTileCamera({
    required String titleName,
    required IconName,
  }) {
    return GestureDetector(
      onTap: () {
        wPushReplaceTo2(
            context,
            ajoutContact(
              Uid: '',
              haveUid: false,
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

  Widget _MyListTileGalery({
    required String titleName,
    required IconName,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              settings: RouteSettings(),
              pageBuilder: (_, __, ___) =>
                  QRViewExample(userData: widget.userData),
              transitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder: (_, animation, __, child) {
                // slide in transition,
                // from right (x = 1) to center (x = 0) screen
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
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

  void selectImage() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _SelectImage();
        });
  }
}
