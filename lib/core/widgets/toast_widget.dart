import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;

class Toast {
  static void show(String message) {
    toast.Fluttertoast.showToast(
      msg: message,
      toastLength: toast.Toast.LENGTH_SHORT,
      gravity: toast.ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
      textColor: Colors.black,
    );
  }
}
