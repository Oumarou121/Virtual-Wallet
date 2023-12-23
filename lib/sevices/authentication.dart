import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtual_wallet_2/models/user.dart';
import 'package:virtual_wallet_2/sevices/database.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _userFromFirebaseUser(User? user) {
    initUser(user);
    return user != null ? AppUser(user.uid) : null;
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  void initUser(User? user) async {
    if (user == null) return;
    // NotificationService.getToken().then((value) {
    //   DatabaseService(user.uid).saveToken(value);
    // });
  }

  // Future authWithPhoneNumber(String phone,
  //     {required Function(String value, int? value1) onCodeSend,
  //     required Function(PhoneAuthCredential value) onAutoVerify,
  //     required Function(FirebaseAuthException value) onFailed,
  //     required Function(String value) autoRetrieval}) async {
  //   _auth.verifyPhoneNumber(
  //       phoneNumber: phone,
  //       timeout: const Duration(seconds: 20),
  //       verificationCompleted: onAutoVerify,
  //       verificationFailed: onFailed,
  //       codeSent: onCodeSend,
  //       codeAutoRetrievalTimeout: autoRetrieval);
  // }

  // Future<void> disconnect() async {
  //   await _auth.signOut();
  //   return;
  // }

  // Future autoVerify({required v}) async {
  //   await _auth.signInWithCredential(v);
  // }

  // // User? get user => _auth.currentUser;

  // Future registerWithPhoneNumber(String smsCode, String verificationId,
  //     {required String name,
  //     required String PhoneNumber,
  //     required String password}) async {
  //   try {
  //     PhoneAuthProvider.credential(
  //         verificationId: verificationId, smsCode: smsCode);
  //     User? user = _auth.currentUser;

  //     if (user == null) {
  //       throw Exception("No user found");
  //     } else {
  //       await DatabaseService(user.uid)
  //           .saveUser(name, 0, '', password, user.uid, PhoneNumber);

  //       return _userFromFirebaseUser(user);
  //     }
  //   } catch (exception) {
  //     print(exception.toString());
  //     return false;
  //   }
  // }

  Future signInWithEmailAndPassword(
      {required TextEditingController email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.text.trim(), password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return exception.runtimeType;
    }
  }

  Future registerWithEmailAndPassword(
      {required String name,
      required String phoneNumber,
      required TextEditingController email,
      required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password);
      User? user = result.user;
      if (user == null) {
        return 'false';
        // throw Exception("No user found");
      } else {
        await DatabaseService(user.uid).saveUser(
            name,
            0,
            '',
            password,
            user.uid,
            phoneNumber,
            '',
            '',
            true,
            false,
            true,
            false,
            'Color1',
            'Français');
        if (result.user != null) return 'true';
        return _userFromFirebaseUser(user);
      }
    } catch (exception) {
      print(exception.toString());
      return exception.toString();
    }
  }

  Future<bool> resetPassword({required TextEditingController email}) async {
    try {
      // ignore: unused_local_variable
      final result =
          await _auth.sendPasswordResetEmail(email: email.text.trim());

      return false;
    } catch (e) {
      return false;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future<bool> signUp(
      {required String name,
      required TextEditingController email,
      required String password}) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password);
      if (result.user != null) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  // Future<bool> signIn(
  //     {required TextEditingController email, required String password}) async {
  //   try {
  //     final result = await _auth.signInWithEmailAndPassword(
  //         email: email.text.trim(), password: password);
  //     if (result.user != null) return true;
  //     return false;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<String> signIn(
      {required TextEditingController email, required String password}) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email.text.trim(), password: password);
      if (result.user != null) return 'true';
      return 'false';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> validateOtp(String smsCode, String verificationId) async {
    final _credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    await _auth.signInWithCredential(_credential);
    return;
  }
}
