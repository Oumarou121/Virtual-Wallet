import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/AddType.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class Retrait extends StatefulWidget {
  Retrait({super.key, required this.MyUid});
  final String MyUid;
  @override
  State<Retrait> createState() => _RetraitState();
}

class _RetraitState extends State<Retrait> {
  late List<Map<String, dynamic>> items = [];

  MessageLenght({required collection}) async {
    List<Map<String, dynamic>> tempsList = [];
    var data = await collection.get();

    data.docs.forEach((element) {
      tempsList.add(element.data());
      if (mounted)
        return setState(() {
          items = tempsList;
        });
    });
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
                // Text(
                // 'My',
                // style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                // ),
                SizedBox(width: 30),
                Text(
                  SwicthLangues(
                      userData: userData, fr: 'Retrait', en: 'Revocation'),
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
              onPressed: () =>
                  wPushReplaceTo2(context, AddType(userData: userData)),
            ))
      ]),
    );
  }

  Widget Call({required AppUserData userData}) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: SwicthColorSecondary(userData: userData)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.call),
          SizedBox(width: 15),
          Text(userData.phone, style: TextStyle(fontSize: 20))
        ],
      ),
    );
  }

  void _destory({required index}) async {
    await FirebaseFirestore.instance
        .collection('Confirm ${widget.MyUid}')
        .doc(items[index]["order"])
        .delete();
  }

  Widget _inputConfirm({required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 50,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          _destory(index: 1);
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
        child: Text('Confirmer le retrait'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var collectionM =
        FirebaseFirestore.instance.collection('Confirm ${widget.MyUid}');
    final user = Provider.of<AppUser?>(context);
    if (user == null) throw Exception("user not found");
    final database = DatabaseService(user.uid);
    return FutureBuilder(
      future: MessageLenght(collection: collectionM),
      builder: (context, snapshot) => StreamProvider<AppUserData?>.value(
        value: database.user,
        initialData: null,
        child: StreamBuilder<AppUserData>(
            stream: database.user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                AppUserData? userData = snapshot.data;
                if (userData == null) return Loading();
                return Scaffold(
                  // backgroundColor: Colors.grey.shade100,
                  body: SafeArea(
                      child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          _top(userData: userData),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                          ),
                          Text(
                              SwicthLangues(
                                  userData: userData,
                                  fr: 'Mon Numéro',
                                  en: 'My Number'),
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w300)),
                          const SizedBox(height: 10),
                          Call(userData: userData),
                          const SizedBox(height: 30),
                          items.length == 2
                              ? _inputConfirm(userData: userData)
                              : CircularProgressIndicator()
                        ],
                      ),
                    ),
                  )),
                );
              } else {
                return Loading();
              }
            }),
      ),
    );
  }
}
