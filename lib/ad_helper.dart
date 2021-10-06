import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';//TODO: Change Banner ad id for android here
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';//TODO: Change Banner ad id for iOS here
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";//TODO: Change Banner ad id for android here
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";//TODO: Change Interstitial ad id for iOS here
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}