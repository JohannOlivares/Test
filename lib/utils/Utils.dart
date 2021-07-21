import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Preference.dart';

class Utils {
  static showToast(BuildContext context, String msg,
      {double duration = 2, ToastGravity? gravity}) {
    if (gravity == null) gravity = ToastGravity.BOTTOM;

    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: Colur.txt_grey,
        textColor: Colur.white,
        fontSize: 14.0);
  }

  static bool isLogin() {
    var uid = Preference.shared.getString(Preference.USER_ID);
    return (uid != null && uid.isNotEmpty);
  }

  static getCurrentDateTime() {
    DateTime dateTime = DateTime.now();
    return "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString()}-${dateTime.minute.toString()}-${dateTime.second.toString()}";
  }
}
