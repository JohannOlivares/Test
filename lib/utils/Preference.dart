// Dart imports:
import 'dart:async';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

/* global class for handle all the preference activity into application */

class Preference {
  // Preference key
  static const String AUTHORIZATION = "Authorization";
  static const String FCM_TOKEN = "FCM_TOKEN";
  static const String USER_DATA = "USER_DATA";
  static const String USER_ID = "USER_ID";
  static const String TOKEN = "TOKEN";
  static const String IS_PURCHASED = "IS_PURCHASED";
  static const String IS_NOTIFICATION_ALLOWED = "IS_NOTIFICATION_ALLOWED";
  static const String PERCENTAGE = "PERCENTAGE";
  static const String NEED_TO_SYNC = "NEED_TO_SYNC";

  static const String TARGET_DRINK_WATER = "TARGET_DRINK_WATER";

  // ------------------ SINGLETON -----------------------
  static final Preference _preference = Preference._internal();

  factory Preference() {
    return _preference;
  }

  Preference._internal();

  static Preference get shared => _preference;

  static SharedPreferences? _pref;

  /* make connection with preference only once in application */
  Future<SharedPreferences?> instance() async {
    if (_pref != null) return _pref;
    await SharedPreferences.getInstance().then((onValue) {
      _pref = onValue;
    }).catchError((onError) {
      _pref = null;
    });

    return _pref;
  }

  // String get & set
  String? getString(String key) {
    return _pref!.getString(key);
  }

  Future<bool> setString(String key, String value) {
    return _pref!.setString(key, value);
  }

  // Int get & set
  int? getInt(String key) {
    return _pref!.getInt(key);
  }

  Future<bool> setInt(String key, int value) {
    return _pref!.setInt(key, value);
  }

  // Bool get & set
  bool? getBool(String key) {
    return _pref!.getBool(key);
  }

  Future<bool> setBool(String key, bool value) {
    return _pref!.setBool(key, value);
  }

  // Array get & set
  List<String>? getStringList(String key) {
    return _pref!.getStringList(key);
  }

  Future<bool> setStringList(String key, List<String> value) {
    return _pref!.setStringList(key, value);
  }

  /* remove  element from preferences */
  Future<bool> remove(key, [multi = false]) async {
    SharedPreferences? pref = await instance();
    if (multi) {
      key.forEach((f) async {
        return await pref!.remove(f);
      });
    } else {
      return await pref!.remove(key);
    }

    return new Future.value(true);
  }

  /* remove all elements from preferences */
  static Future<bool> clear() async {
    // return await _pref.clear();
    // Except FCM token & device info
    _pref!.getKeys().forEach((key) async {
      if (key != FCM_TOKEN && key != IS_NOTIFICATION_ALLOWED) {
        await _pref!.remove(key);
      }
    });

    return Future.value(true);
  }

  static Future<bool> clearTargetDrinkWater() async {
    _pref!.getKeys().forEach((key) async {
      if (key == TARGET_DRINK_WATER) {
        await _pref!.remove(key);
      }
    });
    return Future.value(true);
  }
}
