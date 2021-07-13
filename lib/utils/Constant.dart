


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
  static const STR_CLOSE = "CLOSE";
  static const STR_INFO = "INFO";


  static const TEXT = "1";

  static const TRUE = "True";
  static const FALSE = "False";

  static const CHAT_TYPE_GROUP = "Group";
  static const CHAT_TYPE_PERSONAL = "Personal";

  static const NOTIFICATION_TYPE_ADMIN = "admin";
  static const NOTIFICATION_TYPE_CHAT = "chat";

  static final String redirectUrl = 'http://pandalanhukuk.com';
  static final String clientId = '77obwasea55zmg';
  static final String clientSecret = 'orX0ULsWPiF8iqcH';

  static const INVITATION_PENDING = 0;
  static const INVITATION_ACCEPT = 1;
  static const INVITATION_DECLINE = 2;
  static const LEAVE_GROUP = 4;

  static getMainURL() {
    if (Debug.SANDBOX_API_URL)
      return "http://192.168.29.239/law-game/public";
    else
      return MAIN_URL;
  }

  static String getPrivacyPolicyURL() {
    return getMainURL() + "/privacy_policy.html";
  }

  static String getTermsConditionURL() {
    // return getMainURL() + "/terms_of_service";
    return getMainURL() + "/terms_of_use.html";
  }

  static String getFAQURL() {
    // return getMainURL() + "/faq";
    return getMainURL() + "/faq.html";
  }

  static String getContactUsURL() {
    // return getMainURL() + "/contact_us";
    return getMainURL() + "/faq.html";
  }
}
