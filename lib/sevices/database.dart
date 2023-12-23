import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_wallet_2/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  final CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection("users");

  Future<void> saveUser(
      String name,
      int waterCounter,
      String password,
      String passwordSign,
      String playerUid,
      String phone,
      String token,
      String ImageUrl,
      bool DBiometrique,
      bool CBiometrique,
      bool autoBrightness,
      bool isDark,
      String primaryColor,
      String langues) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'waterCount': waterCounter,
      'password': password,
      'passwordSign': passwordSign,
      'playerUid': playerUid,
      'phone': phone,
      'token': token,
      'ImageUrl': ImageUrl,
      'DBiometrique': DBiometrique,
      'CBiometrique': CBiometrique,
      'autoBrightness': autoBrightness,
      'isDark': isDark,
      'primaryColor': primaryColor,
      'langues': langues
    });
  }

  Future<void> saveToken(String? token) async {
    return await userCollection.doc(uid).update({'token': token});
  }

  AppUserData _userFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("user not found");
    return AppUserData(
        uid: snapshot.id,
        name: data['name'],
        password: data['password'],
        passwordSign: data['passwordSign'],
        waterCounter: data['waterCount'],
        playerUid: data['playerUid'],
        phone: data['phone'],
        token: data['token'],
        ImageUrl: data['ImageUrl'],
        DBiometrique: data['DBiometrique'],
        CBiometrique: data['CBiometrique'],
        autoBrightness: data['autoBrightness'],
        isDark: data['isDark'],
        primaryColor: data['primaryColor'],
        langues: data['langues']);
  }

  Stream<AppUserData> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  List<AppUserData> _userListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _userFromSnapshot(doc);
    }).toList();
  }

  Stream<List<AppUserData>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}
