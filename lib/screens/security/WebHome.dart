import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/authentication/login_screen.dart';
import 'package:virtual_wallet_2/screens/security/TAttente.dart';
import 'package:virtual_wallet_2/screens/security/TConfirm.dart';
import 'package:virtual_wallet_2/screens/security/TRejete.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class WebHome extends StatefulWidget {
  const WebHome({super.key});

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  // Top
  Widget _top({required AppUserData userData}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  SwicthLangues(userData: userData, fr: 'Mon', en: 'My'),
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(width: 10),
                Text(
                  userData.name,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Iconsax.refresh_circle,
              size: 24,
              color: Colors.black,
            ))
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
                SizedBox(
                  height: MediaQuery.of(context).size.height / 13,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100),
                            ),
                            Text(
                              balance,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            )
                          ],
                        ),
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
                          onPressed: () => LoginScreen(userData: userData)),
                    )
                  ],
                ),
              ]),
            ),
          ]),
        ),
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

  Widget _HomeButtonTC(
      {required iconImagePath,
      required titleName,
      required titleSubName,
      required String uid,
      required AppUserData userData}) {
    return GestureDetector(
      onTap: () => setState(() {
        wPushReplaceTo2(
            context,
            TransactionsConfirm(
              MyUid: uid,
              userData: userData,
            ));
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
                    child: Icon(iconImagePath),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleName,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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

  Widget _HomeButtonTR(
      {required iconImagePath,
      required titleName,
      required titleSubName,
      required String uid,
      required AppUserData userData}) {
    return GestureDetector(
      onTap: () => setState(() {
        wPushReplaceTo2(
            context,
            TransactionsRejete(
              MyUid: uid,
              userData: userData,
            ));
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
                    child: Icon(iconImagePath),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleName,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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

  Widget _HomeButtonTA(
      {required iconImagePath,
      required titleName,
      required titleSubName,
      required String uid,
      required AppUserData userData}) {
    return GestureDetector(
      onTap: () => setState(() {
        wPushReplaceTo2(
            context,
            TransactionsAttente(
              MyUid: uid,
              userData: userData,
            ));
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
                    child: Icon(iconImagePath),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleName,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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
    // NotificationService.initialize();
    final user = Provider.of<AppUser?>(context);
    if (user == null) return Loading();
    final database = DatabaseService(user.uid);
    return StreamProvider<AppUserData?>.value(
        value: database.user,
        initialData: null,
        child: StreamBuilder<AppUserData>(
            stream: database.user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                AppUserData? userData = snapshot.data;
                int Amount = userData!.waterCounter;
                return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SafeArea(
                        child: Column(
                          children: [
                            _top(userData: userData),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 3.5,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                      color: Colors.black),
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
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  child: Column(
                                    children: [
                                      // TA
                                      _HomeButtonTA(
                                          uid: user.uid,
                                          userData: userData,
                                          iconImagePath:
                                              Iconsax.transaction_minus,
                                          titleSubName:
                                              'Ce sont les transactions qui ne sont pas encore confirment',
                                          titleName:
                                              'Transactions en Attentées'),
                                      // TR
                                      _HomeButtonTR(
                                          uid: user.uid,
                                          userData: userData,
                                          iconImagePath:
                                              Iconsax.transaction_minus,
                                          titleName: 'Transactions Rejetées',
                                          titleSubName:
                                              'Ce sont les transactions qui ne sont pas confirment'),

                                      // TC
                                      _HomeButtonTC(
                                          uid: user.uid,
                                          userData: userData,
                                          iconImagePath:
                                              Iconsax.transaction_minus,
                                          titleName: 'Tansactions Validées',
                                          titleSubName:
                                              'Ce sont les transactions confirment'),
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
            }));
  }
}
