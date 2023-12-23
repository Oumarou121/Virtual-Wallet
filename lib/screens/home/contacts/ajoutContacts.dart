import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_2/common/loading.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/screens/home/contacts/ContactsHome.dart';
import 'package:virtual_wallet_2/sevices/database.dart';
import 'package:virtual_wallet_2/utils/utils.dart';
import 'package:virtual_wallet_2/widgets/widgets.dart';

// ignore: must_be_immutable
class ajoutContact extends StatefulWidget {
  ajoutContact({super.key, required this.Uid, required this.haveUid});
  String Uid;
  bool haveUid;

  @override
  State<ajoutContact> createState() => _ajoutContactState();
}

class _ajoutContactState extends State<ajoutContact> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String phoneNumber = '';
  String initialphoneNumber = '';
  String Name = '';
  String initialName = '';
  String error = '';
  String YourUid = '';
  String urlImage = '';
  bool _isLoading = false;
  List<Country> countries = [
    Country(
      name: "Niger",
      nameTranslations: {
        "sk": "Niger",
        "se": "Niger",
        "pl": "Niger",
        "no": "Niger",
        "ja": "ニジェール",
        "it": "Niger",
        "zh": "尼日尔",
        "nl": "Niger",
        "de": "Niger",
        "fr": "Niger",
        "es": "Níger",
        "en": "Niger",
        "pt_BR": "Níger",
        "sr-Cyrl": "Нигер",
        "sr-Latn": "Niger",
        "zh_TW": "尼日爾",
        "tr": "Nijer",
        "ro": "Niger",
        "ar": "النيجر",
        "fa": "نیجر",
        "yue": "尼日爾"
      },
      flag: "🇳🇪",
      code: "NE",
      dialCode: "227",
      minLength: 8,
      maxLength: 8,
    ),
  ];

  Widget _inputName({required String initialName, required userData}) {
    return Container(
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        initialValue: initialName,
        // controller: _name,
        decoration: InputDecoration(
            prefixIconColor: SwicthColor(userData: userData),
            hintText: SwicthLangues(userData: userData, fr: 'Nom', en: 'Name'),
            helperText: SwicthLangues(
                userData: userData,
                fr: 'Entert votre nom complet',
                en: 'Entert Full Name'),
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.supervised_user_circle_rounded)),
        onChanged: (value) => setState(() {
          Name = value;
        }),
        validator: (val) => uValidator(
          value: val,
          isRequred: true,
          minLength: 3,
        ),
      ),
    );
  }

  Widget _inputConfirm({required String MyUid, required userData}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 64,
      child: ElevatedButton(
        onPressed: () async {
          if (_formkey.currentState!.validate()) {
            if (phoneNumber.isNotEmpty || initialphoneNumber.length == 12) {
              setState(() {
                _isLoading = true;
              });
              var collection = FirebaseFirestore.instance.collection("users");

              var num =
                  await collection.where("phone", isEqualTo: phoneNumber).get();
              var collection1 =
                  FirebaseFirestore.instance.collection('Contacts $MyUid');

              var num1 = await collection1
                  .where("PhoneNumber", isEqualTo: phoneNumber)
                  .get();
              var num2 = await collection1.where("Name", isEqualTo: Name).get();
              if (num.size == 1) {
                setState(() {
                  _isLoading = true;
                });
                if (num1.size == 1) {
                  setState(() {
                    _isLoading = false;
                    error = SwicthLangues(
                        userData: userData,
                        fr: 'Ce numéro existe déjà dans vos contacts',
                        en: 'This number already exists in your contacts');
                  });
                } else {
                  if (num2.size == 1) {
                    setState(() {
                      _isLoading = false;
                      error = SwicthLangues(
                          userData: userData,
                          fr: 'Ce nom existe déjà dans vos contacts',
                          en: 'This nom already exists in your contacts');
                    });
                  } else {
                    await collection
                        .where("phone", isEqualTo: phoneNumber)
                        .get()
                        .then((snapshot) => snapshot.docs.forEach((document) {
                              setState(() {
                                YourUid = document.reference.id;
                              });
                              print(YourUid);
                            }));
                    SaveContact(MyUid: MyUid, YourUid: YourUid);
                    await Future.delayed(Duration(seconds: 5));
                    wPushReplaceTo2(context,
                        ContactsHome(MyUid: MyUid, userData: userData));
                  }
                }
              } else {
                setState(() {
                  _isLoading = false;
                  error = SwicthLangues(
                      userData: userData,
                      fr: 'Aucun utilisateur trouver',
                      en: 'No User Found');
                });
              }
            }
          }
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
        child: Text(SwicthLangues(
            userData: userData, fr: "Enregistrer", en: "Register")),
      ),
    );
  }

  Widget _SelectImage({required userData}) {
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
                ),
                SizedBox(height: 10),
                _MyListTileCamera(
                  titleName: 'Camera',
                  IconName: Iconsax.camera,
                ),
                // Divider(height: 40, indent: 50, endIndent: 50),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _MyListTileCamera({required String titleName, required IconName}) {
    return GestureDetector(
      onTap: () {
        getImage(source: ImageSource.camera);
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

  Widget _MyListTileGalery({required String titleName, required IconName}) {
    return GestureDetector(
      onTap: () {
        getImage(source: ImageSource.gallery);
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

  void getImage({required ImageSource source}) async {
    Navigator.of(context).pop();

    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
      });
    }
  }

  void selectImage({required userData}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _SelectImage(userData: userData);
        });
  }

  @override
  // ignore: override_on_non_overriding_member
  File? imageFile;

  SaveContact({required String MyUid, required String YourUid}) async {
    if (phoneNumber.isEmpty) {
      if (imageFile == null) {
        var colllection =
            FirebaseFirestore.instance.collection('Contacts $MyUid');
        colllection
            .doc(Name.isEmpty
                ? '${initialName}${initialphoneNumber}'
                : '$Name${initialphoneNumber}')
            .set({
          "ImageUrl": '',
          "Name": Name.isEmpty ? initialName : Name,
          "PhoneNumber": initialphoneNumber,
          "Uid": YourUid,
        });
      } else {
        var reference = FirebaseStorage.instance.ref().child(Name.isEmpty
            ? '${initialName}${initialphoneNumber}.png'
            : '$Name${initialphoneNumber}.png');
        var uploadTask = reference.putFile(imageFile!);
        var taskSnapshot = await uploadTask.whenComplete(() => null);
        this.urlImage = await taskSnapshot.ref.getDownloadURL();

        var colllection =
            FirebaseFirestore.instance.collection('Contacts $MyUid');
        colllection
            .doc(Name.isEmpty
                ? '${initialName}${initialphoneNumber}'
                : '$Name${phoneNumber}')
            .set({
          "ImageUrl": urlImage,
          "Name": Name.isEmpty ? initialName : Name,
          "PhoneNumber": initialName,
          "Uid": YourUid,
        });
      }
    } else {
      if (imageFile == null) {
        var colllection =
            FirebaseFirestore.instance.collection('Contacts $MyUid');
        colllection
            .doc(Name.isEmpty
                ? '${initialName}$phoneNumber'
                : '$Name$phoneNumber')
            .set({
          "ImageUrl": '',
          "Name": Name.isEmpty ? initialName : Name,
          "PhoneNumber": phoneNumber,
          "Uid": YourUid,
        });
      } else {
        var reference = FirebaseStorage.instance.ref().child(Name.isEmpty
            ? '${initialName}$phoneNumber.png'
            : '$Name$phoneNumber.png');
        var uploadTask = reference.putFile(imageFile!);
        var taskSnapshot = await uploadTask.whenComplete(() => null);
        this.urlImage = await taskSnapshot.ref.getDownloadURL();

        var colllection =
            FirebaseFirestore.instance.collection('Contacts $MyUid');
        colllection
            .doc(Name.isEmpty
                ? '${initialName}$phoneNumber'
                : '$Name$phoneNumber')
            .set({
          "ImageUrl": urlImage,
          "Name": Name.isEmpty ? initialName : Name,
          "PhoneNumber": phoneNumber,
          "Uid": YourUid,
        });
      }
    }
    // if (imageFile == null) {
    //   var colllection =
    //       FirebaseFirestore.instance.collection('Contacts $MyUid');
    //   colllection.doc('$Name$phoneNumber').set({
    //     "ImageUrl": '',
    //     "Name": Name.isEmpty ? initialName : Name,
    //     "PhoneNumber": phoneNumber.isEmpty ? initialphoneNumber : phoneNumber,
    //     "Uid": YourUid,
    //   });
    // } else {
    //   var reference =
    //       FirebaseStorage.instance.ref().child('$Name$phoneNumber.png');
    //   var uploadTask = reference.putFile(imageFile!);
    //   var taskSnapshot = await uploadTask.whenComplete(() => null);
    //   this.urlImage = await taskSnapshot.ref.getDownloadURL();

    //   var colllection =
    //       FirebaseFirestore.instance.collection('Contacts $MyUid');
    //   colllection.doc('$Name$phoneNumber').set({
    //     "ImageUrl": urlImage,
    //     "Name": Name.isEmpty ? initialName : Name,
    //     "PhoneNumber": phoneNumber.isEmpty ? initialphoneNumber : phoneNumber,
    //     "Uid": YourUid,
    //   });
    // }
  }

  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) throw Exception("user not found");
    final database = DatabaseService(user.uid);
    final databaseR = DatabaseService(widget.Uid);
    return StreamProvider<AppUserData?>.value(
        value: database.user,
        initialData: null,
        child: StreamBuilder<AppUserData>(
            stream: database.user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                AppUserData? userData = snapshot.data;
                if (userData == null) return Loading();
                return _isLoading
                    ? Loading()
                    : Scaffold(
                        appBar: AppBar(
                          centerTitle: true,
                          title: Text(
                            SwicthLangues(
                                userData: userData,
                                fr: "Nouveau contact",
                                en: "New contact"),
                            style: TextStyle(color: Colors.black, fontSize: 24),
                          ),
                          leading: IconButton(
                            onPressed: () {
                              wPushReplaceTo2(
                                  context,
                                  ContactsHome(
                                      MyUid: widget.Uid, userData: userData));
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
                        body: widget.haveUid
                            ? StreamProvider<AppUserData?>.value(
                                value: databaseR.user,
                                initialData: null,
                                child: StreamBuilder<AppUserData>(
                                    stream: databaseR.user,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        AppUserData? userDataR = snapshot.data;
                                        if (userDataR == null) return Loading();
                                        initialName = userDataR.name;
                                        initialphoneNumber = userDataR.phone;
                                        //code
                                        return _body(
                                            MyUid: user.uid,
                                            initailName: initialName,
                                            initialphoneNumber:
                                                initialphoneNumber,
                                            userData: userData);
                                      }
                                      return Loading();
                                    }))
                            : _body(
                                MyUid: user.uid,
                                initailName: '',
                                initialphoneNumber: '',
                                userData: userData));
              } else {
                return Loading();
              }
            }));
  }

  Widget _body(
      {required String MyUid,
      required String initailName,
      required String initialphoneNumber,
      required userData}) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 200, horizontal: 30),
            child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: [
                        imageFile != null
                            ? CircleAvatar(
                                radius: 90,
                                backgroundImage: FileImage(imageFile!),
                                //backgroundColor: Colors.white,
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 90,
                                backgroundImage:
                                    AssetImage('images/user (2).png'),
                                //backgroundColor: Colors.white,
                              ),
                        Positioned(
                          child: IconButton(
                              onPressed: () {
                                selectImage(userData: userData);
                              },
                              icon: Icon(Icons.add_a_photo)),
                          bottom: -10,
                          left: 130,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _inputName(initialName: initailName, userData: userData),
                    const SizedBox(height: 15),
                    IntlPhoneField(
                      countries: countries,
                      initialValue: initialphoneNumber,
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value.completeNumber;
                        });
                        print(value.completeNumber);
                      },
                      initialCountryCode: 'NE',
                      decoration: InputDecoration(
                        labelText: SwicthLangues(
                            userData: userData,
                            fr: 'Numéro de téléphone',
                            en: 'Phone Number'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _inputConfirm(MyUid: MyUid, userData: userData),
                    Center(
                      child: Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 16)),
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
