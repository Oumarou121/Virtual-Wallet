import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:virtual_wallet_2/screens/home/contacts/ContactsHome.dart';
import 'package:virtual_wallet_2/screens/home/history/HistoryType.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';
// import 'package:virtual_wallet_2/screens/HistoryType.dart';

// ignore: must_be_immutable
class HistorySendNumber extends StatefulWidget {
  HistorySendNumber(
      {super.key,
      required this.MyUid,
      required this.PhoneNumber,
      required this.userData});
  var MyUid;
  String PhoneNumber;
  var userData;

  @override
  State<HistorySendNumber> createState() => _HistorySendNumberState();
}

class _HistorySendNumberState extends State<HistorySendNumber> {
  List<String> docIDs = [];
  bool isLoaded = false;
  String text = "Historique vide";
  // ignore: unused_field
  bool _onclick = true;

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('Send ${widget.MyUid}')
        .where('Phone', isEqualTo: widget.PhoneNumber)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docIDs.add(document.reference.id);
            }));
  }

  void _destory({required index}) async {
    await FirebaseFirestore.instance
        .collection('Send ${widget.MyUid}')
        .doc(docIDs[index])
        .delete();

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
                  'History Send',
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
                        // var collection =
                        //     FirebaseFirestore.instance.collection(widget.MyUid);
                        // _incrementCounter(collection: collection);
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
                  if (docIDs.length == 1) {
                    _destory(index: index);
                    isLoaded = true;
                    text = SwicthLangues(
                        userData: widget.userData,
                        fr: 'Aucun données',
                        en: "No Data");
                    setState(() {});
                    wPushReplaceTo2(
                        context,
                        HistoryType(
                          ID: widget.MyUid,
                          userData: widget.userData,
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

  // @override
  // void initState() async {
  //   var collection = FirebaseFirestore.instance
  //       .collection('Send ${widget.MyUid}')
  //       .orderBy("order", descending: true);
  //   ;
  //   await _incrementCounter(collection: collection);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
          future: getDocId(),
          builder: (context, snapshot) {
            return Center(
                child: Center(
                    child: ListView.builder(
              itemCount: docIDs.length,
              itemBuilder: (context, index) {
                return _HistoryItems(documentId: docIDs[index], index: index);
              },
            )));
          }),
    );
  }

  Widget _HistoryItems({required String documentId, required int index}) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Send ${widget.MyUid}');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Slidable(
                  startActionPane:
                      ActionPane(motion: StretchMotion(), children: [
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
                            //backgroundColor: Colors.white,
                            child: Icon(Iconsax.send_sqaure_2),
                          ),
                          title: Text(data["Name"],
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          subtitle: Text(data["Date"],
                              style: GoogleFonts.poppins(
                                  fontSize: 10, fontWeight: FontWeight.w600)),
                          trailing: Text("${data["Solde"].toString()} ECO",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w400)),
                        ),
                      )),
                ),
              );
            }
            return Text('Loading...');
          } else {
            return Text('');
          }
        });
  }
}
