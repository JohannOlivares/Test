import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Preference.dart';
import 'package:toast/toast.dart';

class Utils {
  static showToast(BuildContext context, String msg,
      {double duration = 2, int gravity}) {
    if (gravity == null) gravity = Toast.BOTTOM;
    Toast.show(msg, context,
        duration: 2,
        gravity: gravity,
        backgroundColor: Colur.txt_grey,
        textColor: Colur.white);
  }

  static bool isLogin() {
    var uid = Preference.shared.getString(Preference.USER_ID);
    return (uid != null && uid.isNotEmpty);
  }




}
