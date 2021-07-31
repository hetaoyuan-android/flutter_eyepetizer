import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LeoToast {

  /// 弹出正常 toast 信息
  static void showTip(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  /// 弹出报错 toast 信息
  static void showError(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
