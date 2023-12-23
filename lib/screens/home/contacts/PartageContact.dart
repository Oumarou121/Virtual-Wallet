import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_wallet_2/screens/home/contacts/ContactsHome.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class PartageContact extends StatefulWidget {
  const PartageContact({super.key});

  @override
  State<PartageContact> createState() => _PartageContactState();
}

class _PartageContactState extends State<PartageContact> {
  Widget qrCode({required PlayerID}) {
    return Container(
        child: Center(
      child: BarcodeWidget(
        data: PlayerID,
        barcode: Barcode.qrCode(),
        color: Colors.black,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) throw Exception("user not found");
    final database = DatabaseService(user.uid);
    return StreamProvider<AppUserData?>.value(
        value: database.user,
        initialData: null,
        child: StreamBuilder<AppUserData>(
            stream: database.user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                AppUserData? userData = snapshot.data;
                if (userData == null) return Loading();

                return Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        onPressed: () {
                          wPushReplaceTo2(
                              context,
                              ContactsHome(
                                MyUid: user.uid,
                                userData: userData,
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
                    // backgroundColor: Colors.grey.shade100,
                    body: Center(
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Text(
                                  SwicthLangues(
                                      userData: userData,
                                      fr: 'Mon Contact',
                                      en: 'My Contact'),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300)),
                              const SizedBox(height: 10),
                              qrCode(PlayerID: user.uid),
                            ],
                          ),
                        ),
                      ),
                    ));
              } else {
                return Loading();
              }
            }));
  }
}
