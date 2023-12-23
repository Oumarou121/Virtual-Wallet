import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/profile/ProfileInfo.dart';
import 'package:virtual_wallet_2/screens/home/profile/ProfileLangues&Fond.dart';
import 'package:virtual_wallet_2/screens/home/profile/ProfileMoi.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virtual_wallet_2/screens/home/profile/ProfileSecurity.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? imageFile;
  String? ImageUrl;
  bool _isLoading = false;

  void selectImage(
      {required String Uid, required database, required userData}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _SelectImage(Uid: Uid, database: database, userData: userData);
        });
  }

  ///Navigation Push
  Future wPushTo(BuildContext context, Widget widget) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                if (userData == null) return Loading();
                return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          _top(userData: userData),
                          SizedBox(height: 20),
                          _isLoading
                              ? SizedBox(height: 180, child: Loading())
                              : _User(
                                  userData: userData,
                                  Uid: user.uid,
                                  database: database),
                          SizedBox(height: 50),
                          _BtnProfileMoi(
                            userData: userData,
                            titleName: SwicthLangues(
                                userData: userData, fr: 'Moi', en: 'My'),
                          ),
                          SizedBox(height: 20),
                          _BtnProfileSecurity(
                            userData: userData,
                            titleName: SwicthLangues(
                                userData: userData,
                                fr: 'Sécurite',
                                en: 'Security'),
                          ),
                          SizedBox(height: 20),
                          _BtnProfileLanguesFond(
                              titleName: 'Langues & Fond',
                              userData: userData,
                              isAuto: userData.autoBrightness,
                              isSombre: userData.isDark),
                          SizedBox(height: 20),
                          _BtnProfileInfo(
                            titleName: 'Info',
                          ),
                        ],
                      ),
                    ));
              } else {
                return Loading();
              }
            }));
  }

  static RandomColor _randomColor = RandomColor();
  Color _color =
      _randomColor.randomColor(colorBrightness: ColorBrightness.primary);
  String? lettreInitial;
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

  Widget affichageImage({required userData}) {
    _checkConnection();
    if (hideUi = true) {
      if (userData.ImageUrl != '') {
        lettreInitial = "";
        return CircleAvatar(
          radius: 90,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage('${userData.ImageUrl}'),
        );
      } else {
        lettreInitial = userData.name[0];
        return CircleAvatar(
          radius: 90,
          backgroundColor: _color,
          child: Text(
            lettreInitial!,
            style: TextStyle(fontSize: 125),
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

  Widget _User({required userData, required Uid, required database}) {
    return Column(
      children: [
        Stack(
          children: [
            // imageFile != null
            //     ? CircleAvatar(
            //         radius: 90,
            //         backgroundImage: FileImage(imageFile!),
            //         backgroundColor: Colors.white,
            //       )
            //     :
            affichageImage(userData: userData),
            Positioned(
              child: IconButton(
                  onPressed: () {
                    selectImage(
                        Uid: Uid, database: database, userData: userData);
                  },
                  icon: Icon(Icons.add_a_photo)),
              bottom: -10,
              left: 130,
            ),
          ],
        )
      ],
    );
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
                Text(
                  SwicthLangues(userData: userData, fr: 'Mon', en: 'My'),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  SwicthLangues(
                      userData: userData, fr: 'Paramètre', en: 'Settings'),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            // Text(
            //   '27 Feb',
            //   style: TextStyle(
            //     fontSize: 14,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.grey,
            //   ),
            // ),
          ],
        ),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Iconsax.setting_3,
              size: 24,
              color: Colors.black,
            ))
      ]),
    );
  }

  Widget _SelectImage(
      {required String Uid, required database, required userData}) {
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
                        userData: userData, fr: 'Galerie', en: 'Galery'),
                    IconName: Iconsax.gallery,
                    Uid: Uid,
                    database: database,
                    userData: userData),
                SizedBox(height: 10),
                _MyListTileCamera(
                    titleName: 'Camera',
                    IconName: Iconsax.camera,
                    Uid: Uid,
                    database: database,
                    userData: userData),
                // Divider(height: 40, indent: 50, endIndent: 50),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _MyListTileCamera(
      {required String titleName,
      required IconName,
      required String Uid,
      required database,
      required userData}) {
    return GestureDetector(
      onTap: () {
        getImage(
            source: ImageSource.camera,
            Uid: Uid,
            database: database,
            userData: userData);
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

  Widget _MyListTileGalery(
      {required String titleName,
      required IconName,
      required String Uid,
      required database,
      required userData}) {
    return GestureDetector(
      onTap: () {
        getImage(
            source: ImageSource.gallery,
            Uid: Uid,
            database: database,
            userData: userData);
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

  void getImage(
      {required ImageSource source,
      required String Uid,
      required database,
      required AppUserData userData}) async {
    Navigator.of(context).pop();

    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
        _isLoading = true;
      });
      var reference = FirebaseStorage.instance.ref().child('$Uid.png');
      var uploadTask = reference.putFile(imageFile!);
      var taskSnapshot = await uploadTask.whenComplete(() => null);
      this.ImageUrl = await taskSnapshot.ref.getDownloadURL();
      await database.saveUser(
          userData.name,
          userData.waterCounter,
          userData.password,
          userData.passwordSign,
          userData.playerUid,
          userData.phone,
          userData.token,
          ImageUrl,
          userData.DBiometrique,
          userData.CBiometrique,
          userData.autoBrightness,
          userData.isDark,
          userData.primaryColor,
          userData.langues);
      affichageImage(userData: userData);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _BtnProfileMoi({required titleName, required userData}) {
    return GestureDetector(
      onTap: () {
        wPushReplaceTo4(
            context,
            ProfileMoi(
              userData: userData,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.deepPurple.shade100,
            color: Colors.grey.shade300,

            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // icon
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 70,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                    height: 70,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _BtnProfileSecurity({required titleName, required userData}) {
    return GestureDetector(
      onTap: () {
        wPushReplaceTo4(
            context,
            ProfileSecurity(
              userData: userData,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.deepPurple.shade100,
            color: Colors.grey.shade300,

            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // icon
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 70,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                    height: 70,
                  ),
                ],
              ),

              Icon(
                Icons.arrow_forward_ios,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _BtnProfileLanguesFond(
      {required titleName,
      required AppUserData userData,
      required bool isAuto,
      required bool isSombre}) {
    return GestureDetector(
      onTap: () {
        wPushReplaceTo4(
            context,
            ProfileLanguesFond(
              userData: userData,
              isAuto: isAuto,
              isSombre: isSombre,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.deepPurple.shade100,
            color: Colors.grey.shade300,

            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // icon
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 70,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                    height: 70,
                  ),
                ],
              ),

              Icon(
                Icons.arrow_forward_ios,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _BtnProfileInfo({required titleName}) {
    return GestureDetector(
      onTap: () {
        wPushReplaceTo4(context, ProfileInfo());
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.deepPurple.shade100,
            color: Colors.grey.shade300,

            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // icon
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 70,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                    height: 70,
                  ),
                ],
              ),

              Icon(
                Icons.arrow_forward_ios,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
