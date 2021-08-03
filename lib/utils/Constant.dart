


import 'package:run_tracker/common/multiselectdialog/MultiSelectDialog.dart';
import 'package:run_tracker/utils/Debug.dart';

class Constant {
  static const RESPONSE_FAILURE_CODE = 400;
  static const RESPONSE_SUCCESS_CODE = 200;

  static const MAIN_URL = "https://pandalanhukuk.com";

  //  static const MAIN_URL = "https://generationteknoloji.com";

  static const DATA_NOT_FOUND = "Data not found";

  static const LOGIN_TYPE_NORMAL = "Normal";
  static const LOGIN_TYPE_GOOGLE = "Google";
  static const LOGIN_TYPE_FACEBOOK = "Facebook";
  static const LOGIN_TYPE_LINKEDIN = "Linkedin";
  static const LOGIN_TYPE_APPLE = "Apple";

  static const STR_BACK = "Back";
  static const STR_STOP = "STOP";
  static const STR_RESUME = "RESUME";
  static const STR_DELETE = "DELETE";
  static const STR_SETTING = "Setting";
  static const STR_SETTING_CIRCLE = "Setting_circle";
  static const STR_CLOSE = "CLOSE";
  static const STR_INFO = "INFO";
  static const STR_OPTIONS = "OPTIONS";

  static const STR_RESET = "Reset";
  static const STR_EDIT_TARGET = "Edit target";
  static const STR_TURNOFF = "Turn off";

  static const ML_100 = 100;
  static const ML_150 = 150;
  static const ML_250 = 250;
  static const ML_500 = 500;

  static const MIN_KG = 20.00;
  static const MAX_KG = 997.00;

  static const MIN_LBS = 45.00;
  static const MAX_LBS = 2200.00;

  static List<MultiSelectDialogItem> daysList = [
    MultiSelectDialogItem("1", "Monday"),
    MultiSelectDialogItem("2", "Tuesday"),
    MultiSelectDialogItem("3", "Wednesday"),
    MultiSelectDialogItem("4", "Thursday"),
    MultiSelectDialogItem("5", "Friday"),
    MultiSelectDialogItem("6", "Saturday"),
    MultiSelectDialogItem("7", "Sunday"),
  ];

  static getMainURL() {
    if (Debug.SANDBOX_API_URL)
      return "http://192.168.29.239/law-game/public";
    else
      return MAIN_URL;
  }

  static String? getPrivacyPolicyURL() {
    return getMainURL() + "/privacy_policy.html";
  }

  static String? getTermsConditionURL() {
    // return getMainURL() + "/terms_of_service";
    return getMainURL() + "/terms_of_use.html";
  }

  static String? getFAQURL() {
    // return getMainURL() + "/faq";
    return getMainURL() + "/faq.html";
  }

  static String? getContactUsURL() {
    // return getMainURL() + "/contact_us";
    return getMainURL() + "/faq.html";
  }
}
