import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const String mainTitle = 'Purpoza';

const Color mainColor = Colors.cyan;

showToast({required dynamic msg, required ToastState toastState}) {
  Fluttertoast.showToast(
      msg: msg.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: toastColor(toastState: toastState),
      textColor: Colors.white,
      fontSize: 16.0);
}

// ignore: constant_identifier_names
enum ToastState { SUCCESS, ERROR }

Color? toastColor({
  required ToastState toastState,
}) {
  Color? toastColors;
  switch (toastState) {
    case ToastState.SUCCESS:
      toastColors = Colors.teal;
      break;
    case ToastState.ERROR:
      toastColors = Colors.red;
      break;
  }
  return toastColors;
}
