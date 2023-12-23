import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/contacts/ContactsHome.dart';
import 'package:virtual_wallet_2/screens/home/send/number/SendNumber.dart';
import 'package:virtual_wallet_2/screens/home/send/number/SendNumberConfirm.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class SendNumberAmount extends StatefulWidget {
  SendNumberAmount(
      {super.key,
      required this.IdR,
      required this.isNumber,
      required this.urlImage,
      required this.Name,
      required this.IdS,
      required this.userData,
      required this.return1});
  final String IdR;
  final String IdS;
  final bool isNumber;
  final bool return1;
  final String urlImage;
  final String Name;
  final userData;
  @override
  State<SendNumberAmount> createState() => _SendNumberAmountState();
}

class _SendNumberAmountState extends State<SendNumberAmount> {
  String text = '';
  static RandomColor _randomColor = RandomColor();
  Color _color =
      _randomColor.randomColor(colorBrightness: ColorBrightness.light);

  Widget _Keyboard({required userDataS, required databaseS, required IdS}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 0),
      child: Column(
        children: [
          Divider(
            color: Colors.black,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 42),
          ),
          Divider(
            color: Colors.black,
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(184, 28, 63, 102)),
                child: TextButton(
                    onPressed: () {
                      if (text.length < 11) {
                        setState(() {
                          text = text + '1';
                          print(text);
                        });
                      }
                    },
                    child: Text(
                      '1',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    )),
              ),
              SizedBox(width: 30),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(184, 28, 63, 102)),
                child: TextButton(
                    onPressed: () {
                      if (text.length < 11) {
                        setState(() {
                          text = text + '2';
                          print(text);
                        });
                      }
                    },
                    child: Text(
                      '2',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    )),
              ),
              SizedBox(width: 30),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(184, 28, 63, 102)),
                child: TextButton(
                    onPressed: () {
                      if (text.length < 11) {
                        setState(() {
                          text = text + '3';
                          print(text);
                        });
                      }
                    },
                    child: Text(
                      '3',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    )),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(184, 28, 63, 102)),
                child: TextButton(
                    onPressed: () {
                      if (text.length < 11) {
                        setState(() {
                          text = text + '4';
                          print(text);
                        });
                      }
                    },
                    child: Text(
                      '4',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    )),
              ),
              SizedBox(width: 30),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(184, 28, 63, 102)),
                child: TextButton(
                    onPressed: () {
                      if (text.length < 11) {
                        setState(() {
                          text = text + '5';
                          print(text);
                        });
                      }
                    },
                    child: Text(
                      '5',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    )),
              ),
              SizedBox(width: 30),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(184, 28, 63, 102)),
                child: TextButton(
                    onPressed: () {
                      if (text.length < 11) {
                        setState(() {
                          text = text + '6';
                          print(text);
                        });
                      }
                    },
                    child: Text(
                      '6',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    )),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(184, 28, 63, 102)),
                child: TextButton(
                    onPressed: () {
                      if (text.length < 11) {
                        setState(() {
                          text = text + '7';
                          print(text);
                        });
                      }
                    },
                    child: Text(
                      '7',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    )),
              ),
              SizedBox(width: 30),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(184, 28, 63, 102)),
                child: TextButton(
                    onPressed: () {
                      if (text.length < 11) {
                        setState(() {
                          text = text + '8';
                          print(text);
                        });
                      }
                    },
                    child: Text(
                      '8',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    )),
              ),
              SizedBox(width: 30),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(184, 28, 63, 102)),
                child: TextButton(
                    onPressed: () {
                      if (text.length < 11) {
                        setState(() {
                          text = text + '9';
                          print(text);
                        });
                      }
                    },
                    child: Text(
                      '9',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    )),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(184, 28, 63, 102)),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        text = '';
                      });
                    },
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    )),
              ),
              SizedBox(width: 30),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(184, 28, 63, 102)),
                child: TextButton(
                    onPressed: () {
                      if (text.length < 11) {
                        setState(() {
                          text = text + '0';
                          print(text);
                        });
                      }
                    },
                    child: Text(
                      '0',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    )),
              ),
              SizedBox(width: 30),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(184, 28, 63, 102)),
                child: TextButton(
                    onPressed: () {
                      if (text.isEmpty) return;
                      setState(() {
                        text = text.substring(0, text.length - 1);
                      });
                    },
                    child: Icon(
                      Icons.backspace_outlined,
                      color: Colors.red,
                    )),
              ),
            ],
          ),
          SizedBox(height: 30),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 64,
            child: ElevatedButton(
              onPressed: () {
                if (text.length >= 3) {
                  if (text.hashCode == 3 && text[0] == 0) {
                  } else {
                    wPushReplaceTo2(
                        context,
                        SendNumberConfirm(
                          IdR: widget.IdR,
                          Facture: int.parse(text),
                          IdS: IdS,
                          isNumber: widget.isNumber,
                          Name: widget.Name,
                          urlImage: widget.urlImage,
                        ));
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    SwicthColor(userData: widget.userData)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              child: Text(SwicthLangues(
                  userData: widget.userData, fr: 'Confirmer', en: 'Confirm')),
            ),
          ),
        ],
      ),
    );
  }

  var lettreInitial;
  Widget affichageImage() {
    if (widget.urlImage != '') {
      lettreInitial = "";
      return CircleAvatar(
        radius: MediaQuery.of(context).size.height / 11,
        backgroundImage: NetworkImage('${widget.urlImage}'),
      );
    } else {
      lettreInitial = widget.Name[0];
      return CircleAvatar(
        radius: MediaQuery.of(context).size.height / 11,
        backgroundColor: _color,
        child: Text(
          lettreInitial,
          style: TextStyle(fontSize: 70),
        ),
      );
    }
  }

  Widget _top() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '      ',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                ),
                SizedBox(width: 20),
                Text(
                  SwicthLangues(
                      userData: widget.userData, fr: 'Envoyer', en: 'Send'),
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
                onPressed: () {
                  if (widget.Name != '' || widget.urlImage != '') {
                    wPushReplaceTo2(
                        context,
                        ContactsHome(
                          MyUid: widget.IdS,
                          userData: widget.userData,
                        ));
                  } else {
                    wPushReplaceTo2(
                        context,
                        SendNumber(
                          IdS: widget.IdS,
                          return1: true,
                        ));
                  }
                }))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                return Scaffold(
                  body: SafeArea(
                      child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _top(),
                          const SizedBox(
                            height: 10,
                          ),
                          widget.isNumber
                              ? affichageImage()
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 7),
                          const SizedBox(
                            height: 20,
                          ),
                          _Keyboard(
                              userDataS: userDataS,
                              databaseS: databaseS,
                              IdS: user.uid)
                        ],
                      ),
                    ),
                  )),
                );
              } else {
                return Loading();
              }
            }));
  }
}
