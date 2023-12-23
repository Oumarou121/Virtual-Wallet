import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:virtual_wallet_2/screens/home/contacts/ContactsHome.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class HistoryReceivePlayer extends StatefulWidget {
  HistoryReceivePlayer(
      {super.key,
      this.MyUid,
      required this.PhoneNumber,
      required this.userData});
  var MyUid;
  String PhoneNumber;
  var userData;
  @override
  State<HistoryReceivePlayer> createState() => _HistoryReceivePlayerState();
}

class _HistoryReceivePlayerState extends State<HistoryReceivePlayer> {
  late List<Map<String, dynamic>> items;
  bool isLoaded = false;
  String text = "Historique vide";
  // ignore: unused_field
  bool _onclick = true;

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
        .collection('Receive ${widget.MyUid}')
        .doc(items[index]["order"])
        .delete();
    var collection = await FirebaseFirestore.instance
        .collection('Receive ${widget.MyUid}')
        .where('Phone', isEqualTo: widget.PhoneNumber)
        .get();
    await _incrementCounter(collection: collection);
    print('Receive ${widget.MyUid}');
    _onclick = true;
  }

  // ignore: unused_element
  Widget _top() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Row(children: [
        Column(
          children: [
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: IconButton(
                        color: Colors.black,
                        icon: Icon(Iconsax.back_square, color: Colors.black),
                        iconSize: 24,
                        onPressed: () => Navigator.pop(context))),
                SizedBox(width: 40),
                Text(
                  'History Receive',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
                SizedBox(width: 80),
                Container(
                    padding: const EdgeInsets.all(00),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: IconButton(
                      color: Colors.black,
                      icon: Icon(Iconsax.refresh_circle),
                      iconSize: 24,
                      onPressed: () async {
                        var collection =
                            FirebaseFirestore.instance.collection(widget.MyUid);
                        _incrementCounter(collection: collection);
                      },
                    ))
              ],
            ),
          ],
        ),
      ]),
    );
  }

  void Succes({required int index}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _Succes(index: index);
        });
  }

  Widget _Succes({required int index}) {
    return Container(
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            SizedBox(height: 8),
            Text(
              SwicthLangues(
                  userData: widget.userData, fr: 'Supprimé', en: 'Delete'),
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 12),
            Text(
              SwicthLangues(
                  userData: widget.userData,
                  fr: 'Etes-vous sûr ? vous ne pouvez pas annuler cette action',
                  en: 'Are you sure? you can\'t undo this action'),
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            IconsButton(
              onPressed: () {
                if (_onclick = true) {
                  setState(() {
                    _onclick = false;
                  });
                  if (items.length == 1) {
                    _destory(index: index);
                    isLoaded = true;
                    text = SwicthLangues(
                        userData: widget.userData,
                        fr: 'Aucun données',
                        en: "No Data");
                    setState(() {});
                    wPushReplaceTo2(
                        context,
                        ContactsHome(
                          userData: widget.userData,
                          MyUid: widget.MyUid,
                        ));
                  } else {
                    _destory(index: index);
                    Navigator.of(context).pop();
                  }
                }
              },
              text: SwicthLangues(
                  userData: widget.userData, fr: 'Supprimé', en: 'Delete'),
              iconData: Icons.delete,
              color: Colors.red,
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
              shape: StadiumBorder(),
            ),
            SizedBox(height: 8),
            IconsOutlineButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              text: SwicthLangues(
                  userData: widget.userData, fr: 'Retour', en: 'Cancel'),
              iconData: Icons.cancel_outlined,
              textStyle: TextStyle(color: Colors.grey),
              iconColor: Colors.grey,
              shape: StadiumBorder(),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var collection = FirebaseFirestore.instance
        .collection('Receive ${widget.MyUid}')
        .where('Phone', isEqualTo: widget.PhoneNumber);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            wPushReplaceTo2(
                context,
                ContactsHome(
                  userData: widget.userData,
                  MyUid: widget.MyUid,
                ));
          },
          icon: Icon(
            Iconsax.back_square,
            color: Colors.black,
          ),
        ),
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
                          return _HistoryItems(index: index);
                        },
                      ))
                    : Text(text));
          }),
    );
  }

  Widget _HistoryItems({required int index}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Slidable(
        startActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(
            onPressed: (context) {
              Succes(index: index);
            },
            borderRadius: BorderRadius.circular(20),
            backgroundColor: Colors.red,
            icon: Icons.delete_outline,
          ),
        ]),
        child: Padding(
            padding: const EdgeInsets.all(6),
            child: Card(
              elevation: 6,
              child: ListTile(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 0),
                    borderRadius: BorderRadius.circular(0)),
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Iconsax.receipt),
                ),
                title: Text(items[index]["Name"],
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                subtitle: Text(items[index]["Date"],
                    style: GoogleFonts.poppins(
                        fontSize: 10, fontWeight: FontWeight.w600)),
                trailing: Text("${items[index]["Solde"].toString()} ECO",
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w400)),
              ),
            )),
      ),
    );
  }
}
