import 'package:flutter/material.dart';

abstract class Languages {

  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get appName;

  String get labelWelcome;

  String get labelInfo;

  String get labelSelectLanguage;

  String get txtWelcomeMapRunnner;

  String get txtImKateYourCoach;

  String get txtBottomSheetDescription;
  String get txtOk;
  String get txtWhatIsYourGender;
  String get txtGenderDescription;
  String get txtHowMuchDoYouWeight;
  String get txtWeightDescription;
  String get txtHowTallAreYou;
  String get txtHeightDescription;
  String get txtMale;
  String get txtFemale;
  String get txtNextStep;
  String get txtKG;
  String get txtLBS;
  String get txtCM;
  String get txtFT;
  String get txtGeneratingWeeklyGoal;
  String get txtYourWeeklyGoalIsReady;
  String get txtHeartHealth;
  String get txtDistance;
  String get txt150MinBriskWalking;
  String get txtPaceBetween9001500MinKm;
  String get txtOR;
  String get txt75MinRunning;
  String get txtPaceover900MinKm;
  String get txtYouCanCombineTheseTwoDescription;
  String get txtSetAsMyGoal;
  String get txtKM;
  String get txtMILE;
  String get txtUseYourLocation;
  String get txtNotnow;
  String get txtAllow;
  String get txtLocationDesc1;
  String get txtLocationDesc2;
  String get txtRunTracker;
  String get txtGoFasterSmarter;
  String get txtSettings;
  String get txtCupCapacityUnits;
  String get txtTarget;
  String get txtReminder;
  String get txtTargetDesc;
  String get txtDrinkWaterReminder;
  String get txtNotifications;
  String get txtSchedule;
  String get txtStart;
  String get txtEnd;
  String get txtInterval;
  String get txtSound;
  String get txtRingtone;
  String get txtMessage;
  String get txtAM;
  String get txtPM;

  String get txtPaceMinPerKM;
  String get txtKCAL;
  String get txtMin;

  String get txtStop;

  String get txtResume;
  String get txtPause;
  String get txtWellDone;
  String get txtDuration;
  String get txtDistanceKM;
  String get txtMovingTime;
  String get txtDetails;
  String get txtShare;
  String get txtNotReally;
  String get txtGood;
  String get txtAreYouSatisfiedWithDescription;
}
