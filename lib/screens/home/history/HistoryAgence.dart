import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:virtual_wallet_2/screens/home/history/HistoryType.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class HistoryAgence extends StatefulWidget {
  HistoryAgence({super.key, this.MyUid, required this.userData});
  var MyUid;
  var userData;

  @override
  State<HistoryAgence> createState() => _HistoryAgenceState();
}

class _HistoryAgenceState extends State<HistoryAgence> {
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
        .collection('Agence ${widget.MyUid}')
        .doc(items[index]["order"])
        .delete();
    var collection = await FirebaseFirestore.instance
        .collection('Agence ${widget.MyUid}')
        .orderBy("order", descending: true);
    await _incrementCounter(collection: collection);
    _onclick = true;
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
              'Delete',
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 12),
            Text(
              'Are you sure? you can\'t undo this action',
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
                    text = "No Data";
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
                  'HistoryAgence',
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

  // @override
  // void initState() async {
  //   var collection = FirebaseFirestore.instance
  //       .collection('Agence ${widget.MyUid}')
  //       .orderBy("order", descending: true);
  //   _incrementCounter(collection: collection);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var collection = FirebaseFirestore.instance
        .collection('Agence ${widget.MyUid}')
        .orderBy("order", descending: true);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            wPushReplaceTo2(
                context,
                HistoryType(
                  ID: widget.MyUid,
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
                        ),
                      )
                    : Text(text));
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SwicthColor(userData: widget.userData),
        onPressed: () async {
          print('Agence ${widget.MyUid}');
          var collection = FirebaseFirestore.instance
              .collection('Agence ${widget.MyUid}')
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
                    child: Icon(Iconsax.send_square4)),
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
