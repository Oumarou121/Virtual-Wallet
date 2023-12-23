import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
// import 'package:virtual_wallet_2/fonction.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/AddType.dart';
import 'package:virtual_wallet_2/screens/home/Receive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_wallet_2/screens/home/contacts/ContactsHome.dart';
import 'package:virtual_wallet_2/screens/home/history/HistoryType.dart';
import 'package:virtual_wallet_2/screens/home/history/Message.dart';
import 'package:virtual_wallet_2/screens/home/send/SendType.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';
// import 'package:virtual_wallet_2/sevices/authentication.dart';

class Home extends StatefulWidget {
  Home({super.key, required String this.MyUid});
  final String MyUid;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  // Top
  Widget _top({required userData, required int lenght, required String Uid}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  SwicthLangues(userData: userData, fr: 'Mon', en: 'My'),
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Text(
                  SwicthLangues(
                      userData: userData, fr: 'Portefeille', en: 'Wallet'),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
        Stack(children: [
          GestureDetector(
            onTap: () {
              wPushReplaceTo4(
                  context,
                  Message(
                    MyUid: Uid,
                    userData: userData,
                  ));
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Iconsax.message,
                size: 24,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            // decoration: BoxDecoration(
            //   color: Colors.grey,
            //   borderRadius: BorderRadius.circular(24),
            // ),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                lenght.toString().padLeft(2, "0"),
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          )
        ])
      ]),
    );
  }

  // Card
  Widget _card(
      {required String id,
      required Color color,
      required String balance,
      required String image,
      required userData}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 40,
          margin: EdgeInsets.only(top: 10, left: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(38),
          ),
          child: Stack(children: [
            _cardBackground(size: 40, pTop: 90, pLeft: 300),
            _cardBackground(size: 140, pBottom: -50, pLeft: 0),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _masterCardLogo(),
                    Text(
                      id,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          SwicthLangues(
                              userData: userData,
                              fr: 'Mon Solde',
                              en: 'My Amount'),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w100),
                        ),
                        Text(
                          balance,
                          style: const TextStyle(
                            color: Colors.white,
                            letterSpacing: 2.5,
                            fontSize: 24,
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          onPressed: () => wPushReplaceTo5(
                              context,
                              AddType(
                                userData: userData,
                              ))),
                    )
                  ],
                ),
              ]),
            ),
          ]),
        ),
        // Positioned(
        //   top: 0,
        //   child: Image.asset(
        //     image,
        //     width: 140,
        //   ),
        // )
      ],
    );
  }

  // MasterCardLogo
  Widget _masterCardLogo() {
    return SizedBox(
      width: 100,
      child: Stack(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          Positioned(
            left: 20,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

// CardBackground
  Widget _cardBackground({
    double size = 40,
    double? pTop,
    double? pBottom,
    double? pLeft,
    double? pRight,
  }) {
    return Positioned(
      left: pLeft,
      top: pTop,
      bottom: pBottom,
      right: pRight,
      child: Transform.rotate(
        angle: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(size / 6),
          ),
          width: size,
          height: size,
        ),
      ),
    );
  }

  Widget _HomeButtonSend(
      {iconImagePath, titleName, titleSubName, required userData}) {
    return GestureDetector(
      onTap: () => setState(() {
        wPushReplaceTo4(context, SendType(userData: userData));
      }),
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
                    child: Image.asset(iconImagePath),
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
                      SizedBox(height: 8),
                      Text(
                        titleSubName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
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

  // ignore: unused_element
  Widget _HomeButtonReceive({iconImagePath, titleName, titleSubName}) {
    return GestureDetector(
      onTap: () => setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Receive()),
        );
      }),
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
                    child: Image.asset(iconImagePath),
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
                      SizedBox(height: 8),
                      Text(
                        titleSubName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
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

  Widget _HomeButtonContacts(
      {iconImagePath,
      titleName,
      titleSubName,
      required MyUid,
      required userData}) {
    return GestureDetector(
      onTap: () => setState(() {
        wPushReplaceTo4(
            context, ContactsHome(MyUid: MyUid, userData: userData));
      }),
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
                    child: Image.asset(iconImagePath),
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
                      SizedBox(height: 8),
                      Text(
                        titleSubName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
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

  Widget _HomeButtonHistory(
      {iconImagePath, titleName, titleSubName, MyUid, required userData}) {
    return GestureDetector(
      onTap: () {
        // _incrementCounter();
        setState(() {
          wPushReplaceTo4(
              context,
              HistoryType(
                userData: userData,
                ID: MyUid,
              ));
        });
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
                    child: Image.asset(iconImagePath),
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
                      SizedBox(height: 8),
                      Text(
                        titleSubName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
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

  @override
  Widget build(BuildContext context) {
    var collectionM =
        FirebaseFirestore.instance.collection('Message ${widget.MyUid}');
    final user = Provider.of<AppUser?>(context);
    if (user == null) return Loading();
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
                    int Amount = userData!.waterCounter;
                    // ignore: unnecessary_null_comparison
                    return GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SafeArea(
                            child: Column(
                              children: [
                                _top(
                                    userData: userData,
                                    lenght: items.length,
                                    Uid: user.uid),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 3.5,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: _card(
                                        id: '***********${userData.playerUid[0]}${userData.playerUid[1]}${userData.playerUid[2]}${userData.playerUid[3]}${userData.playerUid[4]}',
                                        balance: '$Amount Eco',
                                        color: SwicthColor(userData: userData),
                                        image: 'images/jig.png',
                                        userData: userData),
                                  ),
                                ),

                                const SizedBox(height: 30),

                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 18),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Actions',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                // column ->Send + Receive + History
                                GestureDetector(
                                  onTap: () => FocusScope.of(context).unfocus(),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 25),
                                      child: Column(
                                        children: [
                                          // Send
                                          _HomeButtonSend(
                                            userData: userData,
                                            iconImagePath: "images/Icon2.png",
                                            titleName: SwicthLangues(
                                                userData: userData,
                                                fr: 'Envoyer',
                                                en: 'Send'),
                                            titleSubName: SwicthLangues(
                                                userData: userData,
                                                fr: 'Payements et envoies',
                                                en: 'Payment and Income'),
                                          ),

                                          // Receive
                                          _HomeButtonContacts(
                                            userData: userData,
                                            MyUid: user.uid,
                                            iconImagePath: "images/9.png",
                                            titleName: 'Contacts',
                                            titleSubName: SwicthLangues(
                                                userData: userData,
                                                fr: 'Mes Contacts',
                                                en: 'My Conctats'),
                                          ),
                                          // History
                                          _HomeButtonHistory(
                                            userData: userData,
                                            iconImagePath: "images/3.png",
                                            titleName: SwicthLangues(
                                                userData: userData,
                                                fr: 'Historique',
                                                en: 'History'),
                                            titleSubName: SwicthLangues(
                                                userData: userData,
                                                fr: 'Historique de transactions',
                                                en: 'Transactions History'),
                                            MyUid: user.uid,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));
                  } else {
                    return Loading();
                  }
                })));
  }
}
