import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:fluttertoast/fluttertoast.dart';

///widget Loading Application
Widget wAppLoading(BuildContext context) {
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Center(
      child: Platform.isIOS
          ? CupertinoActivityIndicator()
          : CircularProgressIndicator(),
    ),
  );
}

/// Auth Title
Widget wAuthTitle({required String title, required String subtitle}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 3),
        Text(subtitle)
      ],
    ),
  );
}

/// Divider with Text
Widget wTextDivider() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: <Widget>[
        Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'OR CONNECT WITH',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Expanded(child: Divider()),
      ],
    ),
  );
}

/// Sign in with google
Widget wGoogleSingIn({required Function onPressed}) {
  return Container(
    width: double.infinity,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
      ),
      icon: Icon(Icons.adb),
      label: Text('Google'),
      onPressed: () => onPressed,
    ),
  );
}

Widget wTextLink(
    {required String text, required String title, required Function onTap}) {
  return Container(
    margin: EdgeInsets.only(top: 40),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(style: TextStyle(color: DefaultSelectionStyle.defaultColor), text),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.transparent,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          onTap: () => onTap,
        )
      ],
    ),
  );
}

///Navigation Push
Future wPushTo(BuildContext context, Widget widget) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

// Navigation PushReplace
Future wPushReplaceTo1(BuildContext context, Widget widget) {
  return Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

Future wPushReplaceTo2(BuildContext context, Widget widget) {
  return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        settings: RouteSettings(),
        pageBuilder: (_, __, ___) => widget,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, animation, __, child) {
          // slide in transition,
          // from right (x = 1) to center (x = 0) screen
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ));
}

Future wPushReplaceTo4(BuildContext context, Widget widget) {
  return Navigator.push(
      context,
      PageRouteBuilder(
        settings: RouteSettings(),
        pageBuilder: (_, __, ___) => widget,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, animation, __, child) {
          // slide in transition,
          // from right (x = 1) to center (x = 0) screen
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ));
}

Future wPushReplaceTo3(BuildContext context, Widget widget) {
  return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        settings: RouteSettings(),
        pageBuilder: (_, __, ___) => widget,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, animation, __, child) {
          // slide in transition,
          // from bottom (y = 1) to center (y = 0) screen
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ));
}

Future wPushReplaceTo5(BuildContext context, Widget widget) {
  return Navigator.push(
      context,
      PageRouteBuilder(
        settings: RouteSettings(),
        pageBuilder: (_, __, ___) => widget,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, animation, __, child) {
          // slide in transition,
          // from bottom (y = 1) to center (y = 0) screen
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ));
}

/// Submit Button
Widget wInputSubmit(
    {required BuildContext context,
    required String title,
    required Function onPressed}) {
  return Container(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            shadowColor: Theme.of(context).primaryColor,
          ),
          child: Text(title),
          onPressed: () {}));
}

Future wShowToast(String msg) {
  return Fluttertoast.showToast(
    msg: msg,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
  );
}
